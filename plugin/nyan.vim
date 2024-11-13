let s:dir = expand('<sfile>:h:h') . '/data'
let s:index = 0
let s:images = []
let s:offset = get(g:, 'nyancat_offset', 0)

function! s:nyan(...)
  if s:offset > 0
    let l:col = s:offset
  else
    let l:col = &columns - 7 + s:offset
  endif
  if has('win32')
    call writefile([printf("\x1b[s\x1b[%d;%dH", &lines-&cmdheight, l:col)], "CONOUT$", "b")
    call writefile(s:images[s:index % len(s:images)], "CONOUT$", "b")
    call writefile(["\x1b[u"], "CONOUT$", "b")
  else
    call writefile([printf("\x1b[s\x1b[%d;%dH", &lines-&cmdheight, l:col)], "/dev/tty", "b")
    call writefile(s:images[s:index % len(s:images)], "/dev/tty", "b")
    call writefile(["\x1b[u"], "/dev/tty", "b")
  endif
  let s:index += 1
endfunction

function! s:start()
  for i in range(16)
    call add(s:images, readfile(printf('%s/nyan%03d.drcs', s:dir, i), 'b'))
  endfor
  call timer_start(50, function('<SID>nyan'), {'repeat': -1})
endfunction

call s:start()
