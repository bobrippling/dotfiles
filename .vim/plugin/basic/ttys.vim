function! s:Ttys()
	let bufs = getbufinfo({ 'buflisted': 1 })
	call filter(bufs, { i, d -> getbufvar(d.bufnr, '&buftype') ==# 'terminal' })
	call map(bufs, { i, d -> { 'bufnr': d.bufnr, 'windowcount': len(d.windows) } })
	return bufs
endfunction

function! s:TtyDisplay()
	let ttys = s:Ttys()
	call sort(ttys, { a, b -> a.windowcount - b.windowcount })

	echo "nwins\tbuf"
	for buf in ttys
		echo buf.windowcount "\t" buf.bufnr
	endfor
endfunction

function! s:TtySpare(cmd, mods) abort
	let ttys = s:Ttys()

	for tty in ttys
		if tty.windowcount is# 0
			execute a:mods a:cmd tty.bufnr
			return
		endif
	endfor

	echoerr "No spare ttys"
endfunction

" avoid Tty/./ overlap
command! -bar Ttydisplay call s:TtyDisplay()
command! -bar Ttyedit call s:TtySpare("b", <q-mods>)
command! -bar Ttyvsplit call s:TtySpare("vert sb", <q-mods>)
command! -bar Ttysplit call s:TtySpare("sb", <q-mods>)
