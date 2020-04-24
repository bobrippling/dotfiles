function! s:getcmd(start, end) abort
	let fname = expand("%")

	if empty(fname)
		throw "No filename for path2tfs"
	endif

	let [bufnum1, lnum1, col1, off1] = a:start
	let [bufnum2, lnum2, col2, off2] = a:end

	let cmd =
	\ "path2tfs"
	\ . " " . fname
	\ . " " . lnum1
	\ . " " . col1
	\ . " " . lnum2
	\ . " " . (col2+1)

	return cmd
endfunction

function! Path2tfs() abort
	let cmd = s:getcmd(getpos("'<"), getpos("'>"))

	call system(cmd . " | xargs open")
endfunction

command -range Path2tfs call Path2tfs()
"vnoremap <silent> <leader>t :<C-U>call Path2tfs(getpos("'<"), getpos("'>"))<CR>gv
