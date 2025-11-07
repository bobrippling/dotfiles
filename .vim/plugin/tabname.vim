function! TabLabel(n)
	let title = gettabvar(a:n, "title")
	if !empty(title)
		return title
	endif

	let winnr = tabpagewinnr(a:n)
	let bufs = tabpagebuflist(a:n)
	let bufname = bufname(bufs[winnr - 1])

	if empty(bufname)
		return "[No Name]"
	endif
	if bufname[:6] == "term://"
		let b = bufnr(bufname)
		return "<#tty" . b . ">"
	endif

	" could use simplify():
	let bufname = fnamemodify(bufname, ":~:.")

	"let parts = split(bufname, "/", 1)
	"call map(parts, {i, v -> i == len(parts)-1 ? v : v[0] ==# '.' ? v[0:1] : v[0]})
	"let title = join(parts, "/")

	return pathshorten(bufname)
endfunction

function! TabInfo(n)
	let bufs = tabpagebuflist(a:n)

	let is_prev = tabpagenr("#") == a:n
	let modified = 0
	let tty = 0
	for buf in bufs
		let buf_tty = getbufvar(buf, "&buftype") == "terminal"
		let buf_modified = getbufvar(buf, "&modified")

		let tty = tty || buf_tty
		let modified = modified || (!buf_tty && buf_modified)

		if tty && modified
			break " no need to search further
		endif
	endfor

	return (is_prev ? "#" : "") . (tty ? "T" : "") . len(bufs) . "w" . (modified ? "+" : "")
endfunction

function! TabLine()
	let hl = {
	\  "label": "%#TabLine#",
	\  "label_pre": "TabLineItalic",
	\  "label_sel": "%#TabLineSel#",
	\  "label_sel_pre": "TabLineSelItalic",
	\}

	let have_extra_hl = 0
	if hlexists(hl.label_pre) && hlexists(hl.label_sel_pre)
		let pre_output = execute("hi " . hl.label_pre)
		let sel_output = execute("hi " . hl.label_sel_pre)

		let have_extra_hl =
		\ match(pre_output, "\\v(cterm|gui)[fb]g| links to ") >= 0 &&
		\ match(sel_output, "\\v(cterm|gui)[fb]g| links to ") >= 0
	endif

	if have_extra_hl
		let hl.label_pre = "%#" . hl.label_pre . "#"
		let hl.label_sel_pre = "%#" . hl.label_sel_pre . "#"
	else
		let hl.label_pre = "%#TabLineInfo#"
		let hl.label_sel_pre = "%#TabLineInfo#"
	endif

	let tabs = []
	for i in range(1, tabpagenr("$"))
		" select the highlighting
		if i == tabpagenr()
			let hl_lbl = hl.label_sel
			let hl_pre = hl.label_sel_pre
		else
			let hl_lbl = hl.label
			let hl_pre = hl.label_pre
		endif

		" tab page number for mouse clicks
		let line =
		\ "%" . i . "T"
		\ . "%#TabLineIndex#[" . i . "]"
		\ . hl_pre
		\ . "%{TabInfo(" . i . ")} "
		\ . hl_lbl
		\ . "%{TabLabel(" . i . ")}"
		let tabs += [line]
	endfor

	let tail = "%#TabLineFill#%T"

	" ObsessionStatus() guarded safely by g:this_obsession
	if exists("*ObsessionStatus")
		if exists("g:this_obsession") && ObsessionStatus("y", "n") ==# "y"
			" there's also v:this_session, but g:this_obsession is more appropriate
			let relative = fnamemodify(g:this_obsession, ":~:.")
			let baseonly = fnamemodify(relative, ":t")
			let trunc = baseonly ==# relative ? "" : ".../"

			let tail .= " [" . trunc . baseonly . "]"
		else
			let tail .= " [<no session>]"
		endif
	endif

	if &paste
		let tail .= "[paste]"
	endif

	if get(g:, "autosave_enabled", 0)
		let tail .= "[AS" . (get(g:, "autosave_paused", 0) ? "P" : "") . "]"
	endif

	let tab_part = join(tabs, "")

	" truncate at the end furthest from the current tab
	if tabpagenr() > len(tabs) / 2
		let tab_part = "%<" . tab_part
	else
		let tab_part = tab_part . "%<"
	endif

	return tab_part . tail
endfunction

function! GuiTabLabel()
	let i = v:lnum

	return ""
		\ . "%{TabInfo(" . i . ")}"
		\ . "%{TabLabel(" . i . ")}"
endfunction

set tabline=%!TabLine()
if has("gui")
	set guitablabel=%!GuiTabLabel()
endif

function! s:highlight()
	if &background ==# 'light'
		highlight clear Tabline
		highlight clear TabLineFill
		highlight link TabLine StatusLineNC
		highlight TabLineSel ctermfg=0 ctermbg=7 guifg=#eeeeee guibg=#0087af
		"highlight TabLineIndex guifg=#5087af guibg=#afd7ff
	endif

	highlight default link TabLineInfo StatusLineNC
	highlight default link TabLineFill StatusLineNC
	highlight default link TabLineItalic StatusLineNC

	highlight default link TabLineSel StatusLine
	highlight default link TabLineSelItalic StatusLine

	highlight TabLineIndex ctermfg=blue ctermbg=7
endfunction
call s:highlight()

augroup TabLine
	autocmd!

	autocmd ColorScheme * call s:highlight()
augroup END
