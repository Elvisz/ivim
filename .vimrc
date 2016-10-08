" no compatible mode
set nocp

" set encoding with utf-8
scriptencoding utf-8
set encoding=utf8

" load pathogen.vim
set runtimepath+=$IVIM_DIR/plugins/vim-pathogen

" load pathogen plugins
execute pathogen#infect($IVIM_DIR . '/plugins/{}')
execute pathogen#helptags()

" Preference
source $IVIM_DIR/Preference/lib.vim
source $IVIM_DIR/preference/plugins.vim
source $IVIM_DIR/preference/user.vim
source $IVIM_DIR/preference/keymap.vim
