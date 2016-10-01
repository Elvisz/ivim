function! s:jump2prev() abort
  if(buflisted(bufnr("%")))
    silent execute 'bprevious'
    doautocmd User BufferChanged
  endif
endfunction

function! s:jump2next() abort
  if(buflisted(bufnr("%")))
    silent execute 'bnext'
    doautocmd User BufferChanged
  endif
endfunction

function! s:jump2first() abort
  if(buflisted(bufnr("%")))
    silent execute 'bfirst'
    doautocmd User BufferChanged
  endif
endfunction

function! s:jump2last() abort
  if(buflisted(bufnr("%")))
    silent execute 'blast'
    doautocmd User BufferChanged
  endif
endfunction

" ONLY for working bufs
nnoremap <silent><M-j> :<C-u>call <SID>jump2prev()<cr> " previous tab
nnoremap <silent><M-k> :<C-u>call <SID>jump2next()<cr> " next tab
nnoremap <silent><M-h> :<C-u>call <SID>jump2first()<cr> " first tab
nnoremap <silent><M-l> :<C-u>call <SID>jump2last()<cr> " last tab