let s:lastpath = ""

function! s:tfind(mode, mods, path) abort
	let path = a:path
	if strlen(path) == 0
		let path = s:lastpath
		if strlen(path) == 0
			echoerr "No path to search"
			return
		endif
	endif
	let s:lastpath = path

	let tmpfile = "/tmp/.tfind"
	let command = "find '" . path . "' -type f | tmenu >" . tmpfile

	execute "silent !" . command
	redraw!

	let found = readfile(tmpfile)[0]
	call delete(tmpfile)

	if strlen(found) == 0
		return
	endif

	execute a:mods . " " . a:mode . " " . found
endfunction

command! -nargs=? -complete=dir Tedit call s:tfind("e", "<mods>", "<args>")
command! -nargs=? -complete=dir Tsplit call s:tfind("sp", "<mods>", "<args>")
command! -nargs=? -complete=dir Tvsplit call s:tfind("vs", "<mods>", "<args>")
