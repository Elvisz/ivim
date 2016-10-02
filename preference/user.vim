" =========== View ===========
set wildmenu " Turn on the wild menu
set ruler "Always show current position
set cmdheight=2 " Height of the command bar
set number "Show line number"
set showmatch " Show matching brackets when text indicator is over them
set mat=2 " How many tenths of a second to blink when matching brackets
set list listchars=trail:·,precedes:«,extends:»,eol:↲,tab:»» " Show tabs and trailing spaces

" =========== File ===========
set ffs=unix,dos,mac " Use Unix as the standard file type
filetype plugin on " Enable filetype plugins
filetype indent on " Enable filetype indent
set autoread " Set to auto read when a file is changed from the outside
set nobackup nowb noswapfile " no autosave
set hid " A buffer becomes hidden when it is abandoned

" =========== Edit ===========
set history=500 " Sets how many lines of history VIM has to remember
set expandtab smarttab shiftwidth=2 tabstop=2  " Use 2spaces instead of tabs and smart tabs
set ai si "Smart indent
set wrap "Wrap lines
set cpoptions+=n "let wrapped line offset to line number column
set foldmethod=indent foldlevel=999 "Enable folding and none folding by default

" =========== Syntax ===========
syntax enable " Enable syntax highlighting

" =========== Search ===========
set hlsearch " Highlight search results
set incsearch " Makes search act like search in modern browsers
set ignorecase "Ignore case during search"
set smartcase " When searching try to be smart about cases
set nomagic " vim regular expressions turn magic on

" =========== Ignore ===========
" files
set wildignore=*.o,*~,*.pyc,*.exe,*.dll,*.so,*.swp,*.swo
" path
if has("win16") || has("win32")
    set wildignore+=*\\.git\\*,*\\.hg\\*,*\\.svn\\*,*\\.DS_Store\\*,*\\.bundle\\*,*\\.vagrant\\*,*\\tmp\\*,*\\node_modules\\*,*\\bower_components\\*,*\\.sass-cache\\*,*\\coverage\\*,*\\.gems\\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store/*,*/.bundle/*,*/.vagrant/*,*/tmp/*,*/node_modules/*,*/bower_components/*,*/.sass-cache/*,*/coverage/*,*/.gems/*
endif

" =========== Theme ===========
set background=light " dark/light backgroud
source $IVIM_DIR/preference/plugins/vim-colors-solarized.vim " set solarized theme

" =========== Statusline ===========
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" =========== Others ===========
" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" Don't redraw while executing macros (good performance config)
set lazyredraw

" Avoid garbled characters in Chinese language windows OS
let $LANG='en' 
set langmenu=en

" ctags optimization
set autochdir
set tags=tags
