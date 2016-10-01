" Save
nnoremap <silent><M-s> <Esc>:<C-u>w!<cr>

" Save all
nnoremap <silent><M-S> <Esc>:<C-u>wa!<cr>

" Quit VIM without save
nnoremap <silent><M-q> <Esc>:<C-u>qa!<cr>

" Save & Quit VIM
nnoremap <silent><M-Q> <Esc>:<C-u>wqa!<cr>

" Open and open recent
nnoremap <silent><M-p> <Esc>:<C-u>CtrlP<cr>
nnoremap <silent><M-o> <Esc>:<C-u>CtrlPMRU<cr>

" Close the current tab
nnoremap <silent><M-w> :<C-u>call <SID>close_buf()<CR>

" Open/Close file explore
nnoremap <silent><M-e> :<C-u>NERDTreeToggle<CR> " require NERDTree

" Close current split window
nnoremap <silent>\\ :<C-u>close<CR>

" close current buffer
function! s:close_buf() abort
  let l:num = bufnr('%')

  if(buflisted(l:num))
    silent execute 'bprevious'
    doautocmd User BufferChanged
    execute 'bdelete! '.l:num
  endif
endfunction
