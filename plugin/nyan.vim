let s:dir = expand('<sfile>:h:h') . '/data'
let s:index = 0
let s:images = []

function! s:nyan(...)
  call writefile([printf("\x1b[s\x1b[%d;%dH", &lines-&cmdheight, &columns-7)], "/dev/tty", "b")
  call writefile(s:images[s:index % len(s:images)], "/dev/tty", "b")
  call writefile(["\x1b[u"], "/dev/tty", "b")
  let s:index += 1
endfunction

function! s:start()
  for i in range(16)
    call add(s:images, readfile(printf('%s/nyan%03d.drcs', s:dir, i), 'b'))
  endfor
  call timer_start(50, function('<SID>nyan'), {'repeat': -1})
endfunction

call s:start()
