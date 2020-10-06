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
			let parts = split(bufname, "/", 1)
			call map(parts, {i, v -> i == len(parts)-1 ? v : v[0]})
			let title = join(parts, "/")
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

	let pre = a:n . " " . len(bufs) . (tty ? "T" : "") . (modified ? "+" : "")
	return pre . (empty(pre) ? "" : " ")
endfunction

function! TabLine()
	let line = ""

	for i in range(1, tabpagenr("$"))
		" select the highlighting
		if i == tabpagenr()
			let hl_lbl = "%#TabLineSel#"
			let hl_pre = "TabLineSelItalic"
		else
			let hl_lbl = "%#TabLine#"
			let hl_pre = "TabLineItalic"
		endif

		if hlexists(hl_pre)
			let hl_pre = "%#" . hl_pre . "#"
		else
			let hl_pre = hl_lbl
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

set tabline=%!TabLine()
