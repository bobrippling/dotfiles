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
	let s .= "%{StatusLineEnc()}" " 'fileformat'
	let s .= "[%n%{StatusLineBufCount()}]" " buffer number
	let s .= "%{exists('w:quickfix_title') ? ' ' . w:quickfix_title : ''}"

	let s .= "%=" " left + right flex space

	" must be called via %{...} to be in the context of the statusline's window
	let s .= "%{StatusLineAltFile()}"

	let s .= "%{&winfixwidth ? 'W' : ''}"
	let s .= "%{&winfixheight ? 'H' : ''}"
	let s .= "[%{winnr()}]"
	if &ruler
		if empty(&rulerformat)
			let s .= "[%l/%L]" " line number / total
		else
			let s .= "[" . &rulerformat . "]"
		endif
	endif

	return s
endfunction

function! StatusLineBufCount()
	let bufnr = bufnr()

	let nwin_tab = 0
	for b in tabpagebuflist()
		if b is# bufnr
			let nwin_tab += 1
		endif
	endfor

	let nwin = len(win_findbuf(bufnr))
	return nwin > 1
	\ ? '(' . nwin_tab . (nwin > nwin_tab ? 'w/' . nwin . 'a' : '') . ')'
	\ : ''
endfunction

function! StatusLineEnc()
	let ff = &fileencoding
	if empty(ff) || ff == "utf-8"
		return ""
	endif

	return "[" . ff . "]"
endfunction

function! StatusLineAltFile()
	let alt = getreg("#")
	if empty(alt)
		return ""
	endif

	let cur = getreg("%")

	" replace common prefix with '&'
	let l = 0
	for l in range(min([len(alt), len(cur)]))
		if alt[l] !=# cur[l]
			break
		endif
	endfor
	let l -= 1
	while l > 0 && alt[l] !=# "/"
		let l -= 1
	endwhile

	if alt[l] ==# "/" && l > 3
		let alt = "&" . strpart(alt, l)
	endif

	let alt = substitute(alt, "\\v([^/])[^/]+/", "\\1/", "g")

	" maybe don't show it
	let approx_len_rest = 33
	if len(cur) + approx_len_rest + len(alt) >= winwidth(0)
		return ""
	endif

	return " " . alt . " "
endfunction

set statusline=%!StatusLine()

augroup RedrawStatusLine
	autocmd!

	" we may need to redraw on new window creation, since the window numbers may change
	autocmd WinNew * let &ro = &ro
augroup END
