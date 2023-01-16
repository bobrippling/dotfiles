function! StatusLine()
	let nc = ". (g:actual_curwin == win_getid() ? '' : 'NC') . "

	if has("nvim") || has("patch2854")
		let file_highlight = "%{% '%#StatusLineFile'" . nc . "'#' %}"
	else
		let file_highlight = "%#StatusLineFile#"
	endif

	let s = ""

	let s .= " "
	let s .= file_highlight
	let s .= "%f" " filename

	let s .= "%m" " 'modified'
	let s .= "%r" " 'readonly'
	let s .= "%h" " help buffer flag
	let s .= "%w" " preview window flag

	"let s .= "%#StatusLineFlags#"
	let s .= " "
	let s .= "%y" " 'filetype'
	let s .= "%{StatusLineBuftype()}" " 'fileformat'
	let s .= "[%{&ff}]" " 'fileformat'
	let s .= "%{StatusLineEnc()}" " 'fileformat'
	let s .= "[%n%{StatusLineBufCount()}]" " buffer number
	if exists("*SuperSleuthIndicator")
		let s .= "[%{SuperSleuthIndicator()}]"
	endif
	let s .= "%{&spell ? 'S' : ''}"
	let s .= "%{exists('w:quickfix_title') ? ' ' . w:quickfix_title : ''}"

	"let s .= "%#StatusLinePadding#"
	let s .= "%=" " left + right flex space

	let s .= " "

	let s .= file_highlight
	" must be called via %{...} to be in the context of the statusline's window
	let s .= "%{StatusLineAltFile()}"

	"let s .= "%#StatusLineRuler# "
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
	let bufnr = bufnr("")

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

function! StatusLineBuftype()
	let bt = &buftype
	if empty(bt) || bt ==# "help" || bt ==# "terminal"
		return ""
	endif

	return "[" . bt . "]"
endfunction

function! StatusLineAltFile()
	let alt = getreg("#")
	if empty(alt)
		return ""
	endif

	let cur = getreg("%")

	if alt[:6] == "term://"
		let b = bufnr(alt)
		let alt = "<#tty" . b . ">"
	else
		let alt = s:alt_common(cur, alt)
	endif

	" maybe don't show it
	let approx_len_rest = 33
	if len(cur) + approx_len_rest + len(alt) >= winwidth(0)
		return "#.."
	endif

	return alt . " "
endfunction

function! s:alt_common(cur, alt)
	let cur = a:cur
	let alt = a:alt

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

	return pathshorten(alt)
endfunction

set statusline=%!StatusLine()

function! s:highlight()
	highlight default link StatusLineFile StatusLine
	highlight default link StatusLineFlags StatusLine
	highlight default link StatusLinePadding StatusLine
	highlight default link StatusLineRuler StatusLine

	highlight default link StatusLineFileNC StatusLineNC
	highlight default link StatusLineFlagsNC StatusLineNC
	highlight default link StatusLinePaddingNC StatusLineNC
	highlight default link StatusLineRulerNC StatusLineNC

	"highlight StatusLineFlags   cterm=underline ctermbg=7 ctermfg=green gui=bold,reverse guifg=#008f57 guibg=#e4e4e4
	"highlight StatusLinePadding cterm=underline ctermbg=7 ctermfg=12    gui=bold,reverse guifg=#005f87 guibg=#e4e4e4
	"highlight StatusLineRuler   cterm=underline ctermbg=7 ctermfg=blue  gui=bold,reverse guifg=#805f57 guibg=#e4e4e4
endfunction
call s:highlight()

augroup StatusLine
	autocmd!

	" we may need to redraw on new window creation, since the window numbers may change
	autocmd WinNew * let &l:ro = &l:ro

	autocmd ColorScheme * call s:highlight()
augroup END
