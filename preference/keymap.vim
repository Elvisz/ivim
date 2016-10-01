" With a map leader it's possible to do extra key combinations
let mapleader = ","
let g:mapleader = ","

" Re-define commands

" Switch vim windows
nmap <silent><tab><tab> <Esc><C-w>w

source $IVIM_DIR/preference/keymap/file.vim
source $IVIM_DIR/preference/keymap/editor.vim
source $IVIM_DIR/preference/keymap/spell.vim
source $IVIM_DIR/preference/keymap/tabs.vim
source $IVIM_DIR/preference/keymap/goto.vim
source $IVIM_DIR/preference/keymap/git.vim
