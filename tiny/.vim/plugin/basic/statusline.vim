function! StatusLine()
	let s = " "
	let s .= "%f" " filename
	let s .= "%m" " 'modified'
	let s .= "%r" " 'readonly'
	let s .= "%h" " help buffer flag
	let s .= "%w" " preview window flag
	let s .= " "
	let s .= "%y" " 'filetype'
	let s .= "[%{&ff}]" " 'fileformat'
	let s .= "[%n]" " buffer number
	let s .= "%{exists('w:quickfix_title') ? ' ' . w:quickfix_title : ''}"

	let s .= "%=" " left + right flex space

	"let alt = getwinvar(g:statusline_winid, "altfile", "")
	"if !empty(alt)
	"	let alt = substitute(alt, "\\v([^/])[^/]+/", "\\1/", "g")
	"	let s .= alt . " "
	"endif

	let s .= "%{&winfixwidth ? 'W' : ''}"
	let s .= "%{&winfixheight ? 'H' : ''}"
	let s .= "[%{winnr()}]"
	let s .= "[%l/%L]" " line number / total

	return s
endfunction

set statusline=%!StatusLine()

augroup RedrawStatusLine
	autocmd!

	" we may need to redraw on new window creation, since the window numbers may change
	autocmd WinNew * let &ro = &ro
	"autocmd BufReadPost,WinLeave * let w:altfile = @#
augroup END
