function! TabLabel(n)
	let title = gettabvar(a:n, "title")
	if empty(title)
		let winnr = tabpagewinnr(a:n)
		let bufs = tabpagebuflist(a:n)
		let bufname = bufname(bufs[winnr - 1])

		if empty(bufname)
			let title = "[No Name]"
		else
			" could use simplify():
			let bufname = fnamemodify(bufname, ":~:.")

			"let parts = split(bufname, "/", 1)
			"call map(parts, {i, v -> i == len(parts)-1 ? v : v[0] ==# '.' ? v[0:1] : v[0]})
			"let title = join(parts, "/")

			let title = pathshorten(bufname)
		endif
	endif

	return title
endfunction

function! TabPre(n)
	let bufs = tabpagebuflist(a:n)

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

	let pre = "[" . a:n . "] " . len(bufs) . "w" . (tty ? "T" : "") . (modified ? "+" : "")
	return pre . " "
endfunction

function! TabLine()
	let line = ""

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
		\ match(pre_output, "\\v(cterm|gui)[fb]g") >= 0 &&
		\ match(sel_output, "\\v(cterm|gui)[fb]g") >= 0
	endif

	if have_extra_hl
		let hl.label_pre = "%#" . hl.label_pre . "#"
		let hl.label_sel_pre = "%#" . hl.label_sel_pre . "#"
	else
		let hl.label_pre = hl.label
		let hl.label_sel_pre = hl.label_sel
	endif

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
		let line .= "%" . i . "T"

		let line .= ""
		\ . hl_pre
		\ . " "
		\ . "%{TabPre(" . i . ")}"
		\ . hl_lbl
		\ . "%{TabLabel(" . i . ")}"
		\ . " "
	endfor

	let line .= "%#TabLineFill#%T"

	" ObsessionStatus() guarded safely by g:this_obsession
	if exists("*ObsessionStatus")
		if exists("g:this_obsession") && ObsessionStatus("y", "n") ==# "y"
			" there"s also v:this_session, but g:this_obsession is more appropriate
			let relative = fnamemodify(g:this_obsession, ":~:.")
			let baseonly = fnamemodify(relative, ":t")
			let trunc = baseonly ==# relative ? "" : ".../"

			let line .= " [" . trunc . baseonly . "]"
		else
			let line .= " [<no session>]"
		endif
	endif

	return line
endfunction

function! GuiTabLabel()
	let i = v:lnum

	return ""
		\ . "%{TabPre(" . i . ")}"
		\ . "%{TabLabel(" . i . ")}"
endfunction

set tabline=%!TabLine()
if has("gui")
	set guitablabel=%!GuiTabLabel()
endif

if !hlexists("TabLineItalic") && get(g:, "tabname_set_hl", 0)
	" defaults
	hi TabLineSelItalic cterm=bold           ctermfg=green
	hi TabLineItalic    cterm=bold,underline ctermfg=white ctermbg=darkgrey
endif
