function! StatusLine()
	return
	\   " %f%m%r%h%w %y[%{&ff}][%n]%{exists('w:quickfix_title') ? ' ' . w:quickfix_title : ''}"
	\ . "%= "
	\ . "%{&winfixwidth ? 'W' : ''}%{&winfixheight ? 'H' : ''}[%{winnr()}][%l/%L]"
endfunction

set statusline=%!StatusLine()

augroup RedrawStatusLine
	autocmd!

	" we may need to redraw on new window creation, since the window numbers may change
	autocmd WinNew * let &ro = &ro
augroup END
