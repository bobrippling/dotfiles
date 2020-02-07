let s:lastpath = ""
let s:use_term = 1
let s:ctx = v:null

function! s:tfind_complete(tmpfile) abort
	let tmpfile = a:tmpfile
	let found = readfile(tmpfile)[0]
	call delete(tmpfile)

	if strlen(found) == 0
		return
	endif

	execute "e " . found
endfunction

function! s:tfind_term_complete(id, code, ...)
	if a:code != 0
		echo "tfind failed"
		return
	endif

	call s:tfind_complete(s:ctx.tmpfile)
	let s:ctx = v:null
endfunction

function! s:tfind_term(command, tmpfile, editcmd, mods) abort
	let command = a:command
	let s:ctx = {
	\   'tmpfile': a:tmpfile,
	\ }

	if has('nvim')
		call termopen(command, { }) "TODO: pass exit_cb, and ensure we apply editcmd & mods
		"startinsert
	else
		let opts = {
		\   'exit_cb': function("s:tfind_term_complete"),
		\ }

		if a:editcmd == "e"
			let opts.curwin = v:true
		elseif a:editcmd == "vs"
			let opts.vertical = v:true
		elseif a:editcmd == "sp"
			" ok
		else
			throw "invalid editcmd"
		endif

		" TODO: 'mods': a:mods,

		let s:ctx.term = term_start([&shell, &shellcmdflag, command], opts)
	endif

  return
endfunction

function! s:tfind(editcmd, mods, path) abort
	let path = a:path
	if strlen(path) == 0
		let path = s:lastpath
		if strlen(path) == 0
			echoerr "No path specified - :Tfind <path>"
			return
		endif
	endif
	let s:lastpath = path

	let tmpfile = "/tmp/.tfind"
	let command = "find '" . path . "' -type f | tmenu >" . tmpfile

	if has("terminal")
		call s:tfind_term(command, tmpfile, a:editcmd, a:mods)
	else
		execute "silent !" . command
		redraw!
		call s:tfind_complete(tmpfile, a:editcmd, a:mods)
	endif
endfunction

command! -nargs=? -complete=dir Tedit call s:tfind("e", "<mods>", "<args>")
command! -nargs=? -complete=dir Tsplit call s:tfind("sp", "<mods>", "<args>")
command! -nargs=? -complete=dir Tvsplit call s:tfind("vs", "<mods>", "<args>")
