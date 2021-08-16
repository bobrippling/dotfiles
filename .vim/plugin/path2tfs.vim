function! s:getcmd(start, end) abort
	let fname = expand("%")

	if empty(fname)
		throw "No filename for path2tfs"
	endif

	let version_arg = ""
	if fname =~? '^fugitive://'
		let components = split(fname, "/", 1)
		let git_index = index(components, ".git")

		let ver = components[git_index + 2]
		let fname = join(components[git_index + 3:], "/")

		let version_arg = " -c " . ver
	endif

	let [bufnum1, lnum1, col1, off1] = a:start
	let [bufnum2, lnum2, col2, off2] = a:end

	let cmd =
	\ "path2tfs"
	\ . version_arg
	\ . " " . fname
	\ . " " . lnum1
	\ . " " . col1
	\ . " " . lnum2
	\ . " " . (col2+1)

	return cmd
endfunction

function! Path2tfs(switches) abort
	let cmd = s:getcmd(getpos("'<"), getpos("'>"))
	let mode = "open"

	let i = 0
	while i < len(a:switches)
		let sw = a:switches[i]
		if sw ==# "-s" || sw ==# "--show"
			let mode = "show"
		elseif sw ==# "-r" || sw ==# "--reg"
			let i += 1
			if i == len(a:switches)
				echoerr "Need register for -r/--reg"
				return
			endif
			let mode = "reg"
			let reg = a:switches[i]
		else
			echoerr "Invalid switch " sw
			return
		endif
		let i += 1
	endwhile

	let url = substitute(system(cmd), "\n$", "", "")

	if mode ==# "open"
		call system("xargs open", url)
	elseif mode ==# "show"
		echo url
	elseif mode ==# "reg"
		let charwise = "c"
		call setreg(reg, url, charwise)
	endif
endfunction

command! -range -nargs=* Path2tfs call Path2tfs([<f-args>])
"vnoremap <silent> <leader>t :<C-U>call Path2tfs(getpos("'<"), getpos("'>"))<CR>gv
