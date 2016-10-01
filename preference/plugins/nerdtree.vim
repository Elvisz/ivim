" Open NERDTree when vim start up
autocmd vimenter * NERDTree

" Open NERDTree when even no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close vim if no files were specified
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Show hidden files as default
let NERDTreeShowHidden=1

" Hide files/folders on NERDTree
:let g:NERDTreeIgnore=['^.git$', '^.svn$', '^.hg$', '^.vscode$', '^CVS$', '^.idea$', '^node_modules$', '^bower_components$', '^tmp$', '^.bundle$', '^.vagrant$', '^.DS_Store$']

" Auto open nerdtree when open with tab
let g:nerdtree_tabs_open_on_console_startup=1
