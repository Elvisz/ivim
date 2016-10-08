augroup ivim
  autocmd!
  autocmd BufWinEnter,WinEnter,BufDelete * call WindowClose()
  autocmd TextChanged,TextChangedI * call TextChange()
augroup END

function! WindowClose()
  if get(t:, '_win_count', 0) > winnr('$')
    doautocmd User WinClosePost "after close any window
  endif
  let t:_win_count = winnr('$')
endfun

function! TextChange()
  if(exists("s:timer"))
    call timer_stop(s:timer)
  endif

  let s:timer = timer_start(400, "HandleTextChange")
endfun

function! HandleTextChange(timerId)
  doautocmd User BufferChanged
  unlet s:timer
endfun

