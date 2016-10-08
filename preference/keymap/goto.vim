autocmd FileType javascript nnoremap <buffer> <silent> <M-d> :<C-u>TernDef<cr>

autocmd VimEnter call s:ripper_tags_start()
autocmd VimLeave call s:ripper_tags_end()
autocmd BufWrite *.rb :call s:ripper_tags_start()
autocmd FileType ruby nnoremap <buffer> <silent> <M-d> :exec("tag ".expand("<cword>"))<CR>

function! s:ripper_tags_start()
  let s:job = job_start('ripper-tags -R .')
endfun

function! s:ripper_tags_end()
  job_stop(s:job)
endfun
