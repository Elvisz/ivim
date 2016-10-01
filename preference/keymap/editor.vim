" =========== Copy and Paste ===========
vnoremap <silent> <M-c> "+y <CR> " copy select text to clipboard
nnoremap <silent> <M-v>v "+p <CR> " paste from clipboard

" =========== Undo ===========
"set undofile                " Save undo's after file closes
"set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=10000        " How many undos
set undoreload=10000        " number of lines to save for undo

" =========== Search ===========
" require incsearch.vim x fuzzy x vim-easymotion
function! s:config_easyfuzzymotion(...) abort
return extend(copy({
\   'converters': [incsearch#config#fuzzy#converter()],
\   'modules': [incsearch#config#easymotion#module()],
\   'keymap': {"\<CR>": '<Over>(easymotion)'},
\   'is_expr': 0,
\   'is_stay': 1
\ }), get(a:, 1, {}))
endfunction
nnoremap <silent><expr> / incsearch#go(<SID>config_easyfuzzymotion()) " Search and motion
nnoremap <silent> ;; :noh<cr> " Clear search highlight

" =========== Folder ===========
nnoremap <silent> <M-l> @=((foldclosed(line('.')) < 0) ? 'zc':'zo')<CR>
nnoremap <silent> <M-l>l :let &l:foldlevel = (&l:foldlevel ==# 1 ? 999 : 1)<CR>

" =========== Indent/Unindent ===========
vnoremap <silent> <tab> >
vnoremap <silent> <S-tab> <

" =========== Format ===========
nnoremap <silent> <M-L> gg=G <CR> " Format cuurent file

" =========== Highlight Current Line/Colume ===========
nnoremap <silent> <M-h> :setlocal cursorline! cursorcolumn!<CR>

" =========== Movement ===========
" Move a line or range up/down by ALT+k\j
nnoremap <silent> <S+Down> :m .+1<CR>==
nnoremap <silent> <S+Up> :m .-2<CR>==
inoremap <silent> <S+Down> <Esc>:m .+1<CR>==gi
inoremap <silent> <S+Up> <Esc>:m .-2<CR>==gi
vnoremap <silent> <S+Down> :m '>+1<CR>gv=gv
vnoremap <silent> <S+Up> :m '<-2<CR>gv=gv

" Select all
noremap <silent> <M-a> <esc>ggVG<CR>
