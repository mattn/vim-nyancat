if has('gui_running')
  finish
endif
let s:dir = expand('<sfile>:h:h') . '/data'
let s:index = 0
let s:images = []
let s:offset = get(g:, 'nyancat_offset', 0)
let s:device = has('win32') ? 'CONOUT$' : '/dev/tty'

function! s:nyan(...)
  let l:col = s:offset > 0 ? s:offset : &columns - 7 + s:offset
  call writefile([printf("\x1b[s\x1b[%d;%dH", &lines-&cmdheight, l:col)], s:device, "b")
  call writefile(s:images[s:index % len(s:images)], s:device, "b")
  call writefile(["\x1b[u"], s:device, "b")
  let s:index += 1
endfunction

function! s:start()
  for i in range(16)
    call add(s:images, readfile(printf('%s/nyan%03d.drcs', s:dir, i), 'b'))
  endfor
  call timer_start(50, function('<SID>nyan'), {'repeat': -1})
endfunction

call s:start()
