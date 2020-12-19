function! Ttys()
	let bufs = getbufinfo({ 'buflisted': 1 })
	call filter(bufs, { i, d -> getbufvar(d.bufnr, '&buftype') ==# 'terminal' })
	call map(bufs, { i, d -> { 'bufnr': d.bufnr, 'windowcount': len(d.windows) } })
	call sort(bufs, { a, b -> a.windowcount - b.windowcount })
	return bufs
endfunction

function! TtysShow()
	echo "window\tbuf"
	for buf in Ttys()
		echo buf.windowcount "\t" buf.bufnr
	endfor
endfunction

command TtysShow call TtysShow()
