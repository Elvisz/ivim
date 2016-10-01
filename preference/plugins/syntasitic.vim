let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Javascript
let g:syntastic_javascript_checkers = ['eslint']

" Ruby
" let pass --my --args --here to the ruby mri checker
let g:syntastic_ruby_mri_args = "--my --args --here"

" Python
let g:syntastic_python_checkers=['pyflakes']

" Go
let g:syntastic_go_checkers = ['go', 'golint', 'errcheck']

" Custom CoffeeScript SyntasticCheck
func! SyntasticCheckCoffeescript()
    let l:filename = substitute(expand("%:p"), '\(\w\+\)\.coffee', '.coffee.\1.js', '')
    execute "tabedit " . l:filename
    execute "SyntasticCheck"
    execute "Errors"
endfunc
" nnoremap <silent> <leader>l :call SyntasticCheckCoffeescript()<cr>
