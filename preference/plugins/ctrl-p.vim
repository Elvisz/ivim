" CtrlP local working directory
let g:ctrlp_working_path_mode = 'ra'

" Show only MRU files in the working directory.
let g:ctrlp_mruf_relative = 1

" persist the cache
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'

if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif
