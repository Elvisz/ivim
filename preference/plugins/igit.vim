" auto cmds
augroup igit
  autocmd!
  autocmd BufEnter * :call s:igit.refresh()
  autocmd User BufferChanged :call s:igit.refresh()
  autocmd User WinClosePost :call s:igit.resize_git_blame_win()
augroup END

" ---------- local parameters ----------
let s:git_blame_buf_name = 'GitBlameHelper'
let s:git_diff_reg = '^@@ -\(\d\+\),\?\(\d*\) +\(\d\+\),\?\(\d*\) @@'
let s:datetime_reg = '\(\d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}:\d\{2} [-+]\{1}\d\{4}\)'
let s:datetime_reg_group = '\(\d\{4}\)-\(\d\{2}\)-\(\d\{2}\) \(\d\{2}\):\(\d\{2}\):\(\d\{2}\) \([-+]\)\(\d\{2}\)\d\{2}'
let s:git_blame_sha_reg = '^\(\S\{8}\)'
let s:git_blame_info_reg = '(\([^)]\+\)\s\+\d\+)\(\S\+\)\@!'
let s:git_blame_user_and_date_reg = '\(.\+\)\(\s\+'.s:datetime_reg.'\)'
let s:days_to_month = [0,31,59,90,120,151,180,212,243,273,304,334]

let s:git_blame_win_width = 20

" copy the current opened buffer content to temp file
let s:temp_file = tempname()
" after current opened buffer changes, we need also write content to another temp file
let s:temp_buffer = tempname()

" ---------- utils ---------- 
let s:utils = {}

function! s:utils.git_cwd() abort
    return expand(system("git rev-parse --show-toplevel | tr -d '\\n'"))
endfunction

function! s:utils.relative_git_cwd(path) abort
    return substitute(a:path, s:utils.git_cwd() . "/" , "", "")
endfunction

function! s:utils.scroll(line) abort
    let l:offset = a:line - line('w0')
    if l:offset < 0
        execute "normal! ".abs(l:offset)."\<C-y>"
    else
        execute "normal! ".abs(l:offset)."\<C-e>"
    endif

    execute "normal! ".a:line."G"
endfunction

" snapshot current editing buffer and file in git
function! s:utils.snapshot_current_file_and_buf() abort
  " save current opened buffer
  execute 'silent noautocmd write!' .s:temp_buffer

  " copy current file to a temp file
  call system('git show :'.s:utils.relative_git_cwd(expand('%:p')).' > '.s:temp_file)
endfunction

" trim left and right
function! s:utils.trim(str) abort
  return join(filter(split(a:str, ' '), 'v:val != ""'), ' ')
endfunction

" scroll window
function! s:utils.scroll_win(line) abort
  return join(filter(split(a:str, ' '), 'v:val != ""'), ' ')
endfunction

" date to dic
function! s:utils.date_offset(datestr) abort
  let l:datetime = matchlist(a:datestr, s:datetime_reg_group)
  let l:year = l:datetime[1]
  let l:month = +l:datetime[2]
  let l:is_leap_year = l:year % 4 == 0 && l:year % 100 != 0 || l:year % 400 == 0
  " git first release at 2005
  let l:years = l:year - 2004
  " years to second, with leap years
  let l:offset = ((l:years - 1) * 365 + (l:is_leap_year && l:month > 2 ? l:years : l:years - 1) / 4 ) * 24 * 60 * 60
  " month to second
  let l:offset += s:days_to_month[l:month - 1] * 24 * 60 * 60
  " days to second
  let l:offset += l:datetime[3] * 24 * 60 * 60
  " hours to second
  let l:offset += l:datetime[4] * 60 * 60
  " minutes to second
  let l:offset += l:datetime[5] * 60
  " second
  let l:offset += l:datetime[6]
  " zone to second
  let l:zone = +l:datetime[8] * 60 * 60

  if(l:datetime[7] ==# '+')
    let l:offset -= l:zone
  else
    let l:offset += l:zone
  endif

  return l:offset
endfunction


let s:utils.git = {}

" new files not added to git
function! s:utils.git.is_exclude(file) abort
  return index(split(system('git ls-files --others --exclude-standard'), '\n'), a:file) > -1
endfunction

" git blame lines
function! s:utils.git.current_buf_blame_lines() abort
  let l:blames = []

  for blame in split(system('git blame '.expand('%')), '\n')
    if(match(blame, "00000000 (Not Committed Yet") == -1)
      let l:blames = add(l:blames, blame)
    endif
  endfor

  return l:blames
  " return map(split(system('git blame '.expand('%')), '\n'), 'v:val')
endfunction

" git diff lines, get the diff lines info but the detail changes
function! s:utils.git.current_buf_diff_lines() abort
  let l:lines = []

  call s:utils.snapshot_current_file_and_buf()
  for diff in split(system('git diff --no-ext-diff --no-color -U0 -- '.s:temp_file.' '.s:temp_buffer), '\n')
    let l:modifications = matchlist(diff, s:git_diff_reg)
    if(len(l:modifications) > 1)
      let l:lines = add(l:lines, s:utils.git.diff_line_to_dict(l:modifications))
    endif
  endfor

  return l:lines
endfunction

" '@@ from_line,from_count to_line,to_count @@' to { 'from': { 'line': from_line, 'count': from_count}, 'to': { 'line': to_line, 'count': to_count}}
function! s:utils.git.diff_line_to_dict(modifications) abort
  let l:from_line = str2nr(a:modifications[1])
  let l:from_count = (a:modifications[2] == '') ? 1 : str2nr(a:modifications[2])
  let l:to_line = str2nr(a:modifications[3])
  let l:to_count = (a:modifications[4] == '') ? 1 : str2nr(a:modifications[4])

  return { 'from': { 'line': l:from_line, 'count': l:from_count}, 'to': { 'line': l:to_line, 'count': l:to_count}}
endfunction


" ---------- igit global ----------
" plugin global config
let g:igit = { 'ignore': ['GitBlameHelper'] }

" ---------- igit local ----------
let s:igit = {}
let s:file = {}
let s:buffer = {}

" if current buffer is a opened file
function! s:igit.watchable() abort
  if(s:file.exists())
    let l:log = system("git log -- ".expand('%'))
    let l:fatal = matchlist(l:log, "^fatal:.\+is outside repository")
    return len(l:fatal) == 0 || !empty(l:log)
  endif

  return 0
endfunction

" if current buffer is a file buffer
function! s:file.exists() abort
  let l:file = expand('%')
  return !empty(l:file) && filereadable(l:file)
endfunction

" if current buffer is listed
function! s:buffer.listable() abort
  return &buflisted && buflisted(bufnr('%'))
endfunction

" if current file is listed
function! s:igit.ignored() abort
  return index(g:igit.ignore, expand('%')) == -1
endfunction

" this should be executed in current open buffer
function! s:igit.refresh() abort
  call s:igit.git_blame_win_refresh()
endfunction

" if git blame window is open
function! s:igit.is_git_blame_win_opened() abort
  return exists("b:git_blame_win_opened") && b:git_blame_win_opened
endfunction

" git_blame_win refresh
function! s:igit.git_blame_win_refresh() abort
  if(s:igit.watchable())
    if(s:igit.is_git_blame_win_opened())
      call s:igit.create_update_git_blame_win()
    else
      call s:igit.git_blame_win_close()
    endif
  else
    " new buffer will close the blame window
    if(s:buffer.listable() && !s:file.exists())
      call s:igit.git_blame_win_close()
    endif
  endif
endfunction

" close git blame window
function! s:igit.git_blame_win_close() abort
  let b:git_blame_win_opened = 0
  let &l:wrap = &g:wrap
  silent! execute 'close '.bufwinnr(s:git_blame_buf_name)
  setlocal noscrollbind
endfunction

" resize git blame window
function! s:igit.resize_git_blame_win() abort
  let l:git_blame_win = bufwinnr(s:git_blame_buf_name)

  if(l:git_blame_win > -1)
    silent! execute l:git_blame_win .' '. s:git_blame_win_width .'wincmd |'
  endif
endfunction

" create or update git blame window
function! s:igit.create_update_git_blame_win() abort
  let l:file = expand('%')
  if(s:utils.git.is_exclude(l:file))
    return "do nothing for none git files
  endif

  let l:blames = s:igit.current_buf_git_blame_lines()
  if(!len(l:blames))
    return "do nothing for none blames files, may something wrong"
  endif

  let b:git_blame_win_opened = 1
  let l:prev_buf = bufnr('%')
  let l:scroll_at = line('w0')
  let l:git_blame_win = bufwinnr(s:git_blame_buf_name)
  let &l:wrap = 0

  if(l:git_blame_win > -1)
    " move to git blame window
    silent! execute l:git_blame_win .' wincmd w'
    setlocal noscrollbind
  else
    if(bufexists(s:git_blame_buf_name))
      silent! execute 'noautocmd vertical '.s:git_blame_win_width.' split '.s:git_blame_buf_name
    else
      silent! execute 'noautocmd vertical '.s:git_blame_win_width.' new '.s:git_blame_buf_name
    endif
    setlocal winfixwidth nonumber nomodified nomodifiable nowrap nobuflisted
    setlocal buftype=nofile bufhidden=hide noswapfile
  endif

  " update blames
  setlocal modifiable
  " delete all lines in the buffer
  silent! 1,$delete _
  " update git blame to current opened buffer
  call setline(1, l:blames)
  call s:utils.scroll(l:scroll_at)

  " recovery the nomodifiable and scrollbind
  setlocal nomodifiable scrollbind

  " setup status line
  let &l:statusline = "Blame"

  " back to prev window
  silent! execute bufwinnr(l:prev_buf) .' wincmd w'
  setlocal scrollbind
endfunction

" process git blame lines
function! s:igit.current_buf_git_blame_lines()
  let l:blame_lines = []
  let l:origin_blames = s:utils.git.current_buf_blame_lines()

  for diff in s:utils.git.current_buf_diff_lines()
    let l:from_index = diff.from.line ? diff.from.line - 1 : diff.from.line
    let l:to_index = diff.to.line ? diff.to.line - 1 : diff.to.line
    let l:from_count = diff.from.count
    let l:to_count = diff.to.count
    let l:is_modify = l:from_index == l:to_index && l:from_count == l:to_count

    if(l:from_count > l:to_count || l:is_modify)
      " remove removed lines from blame lines
      call remove(l:origin_blames, l:from_index, l:from_index + l:from_count - 1)     
    endif

    " add modified or added lines to blame lines
    if(l:to_count || l:is_modify)
      call extend(l:origin_blames, repeat([''], l:to_count), l:to_index)
    endif
  endfor

  for line in l:origin_blames
    let l:blame_lines = add(l:blame_lines, s:igit.git_blame_line(line))
  endfor

  return l:blame_lines
endfunction

" format git blame line
function! s:igit.git_blame_line(blame) abort
  if(a:blame ==# '')
    return ''
  endif

  let l:sha = matchlist(a:blame, s:git_blame_sha_reg)[1]
  let l:info = matchlist(a:blame, s:git_blame_info_reg)[1]

  let l:info_list = matchlist(l:info, s:git_blame_user_and_date_reg)
  let l:author = l:info_list[1]
  let l:last_modified = s:igit.last_modified(l:info_list[3])

  return l:sha .' '. l:last_modified 
endfunction

" format last modified
function! s:igit.last_modified(datetime) abort
  let l:now = s:utils.date_offset(strftime("%Y-%m-%d %H:%M:%S %z"))
  let l:datetime = s:utils.date_offset(a:datetime)
  let l:last_modified = l:now - l:datetime
  let l:today_offset = 60 * 60 * strftime('%H') + 60 * strftime('%M') + strftime('%S')
  let l:date = matchlist(a:datetime, s:datetime_reg_group)

  if(l:last_modified < 60 * 60)
    return 'Minutes ago'
  endif

  if(l:last_modified < l:today_offset)
    return 'Today'
  endif

  if(l:last_modified < 60 * 60 * 24 + l:today_offset)
    return 'Yesterday'
  endif

  if(l:last_modified < 60 * 60 * 24 * 6 + l:today_offset)
    return 'This week'
  endif

  return l:date[1].'/'.l:date[2].'/'.l:date[3]
endfunction

" ---------- Public APIs ---------
function g:igit.ToggleGitBlameWin() abort
  if(s:igit.watchable())
    if(s:igit.is_git_blame_win_opened())
      call s:igit.git_blame_win_close()
    else
      call s:igit.create_update_git_blame_win()
    endif
  endif
endfunction

command! ToggleGitBlame call g:igit.ToggleGitBlameWin()
