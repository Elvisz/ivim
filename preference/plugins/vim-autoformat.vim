let g:formatdef_jscs = '"jscs -c ' . $IVIM_DIR . '.jscsrc -x"'
let g:formatters_javascript = ['jscs']
nnoremap <silent> <M-L> :Autoformat<CR> " Format current file