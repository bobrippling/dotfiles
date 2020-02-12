let s:use_term = 1
let s:ctx = v:null
let s:lastpath = ""

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
		echo "tfind subcommand exited with " . a:code
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

function! s:tfind(editcmd, mods, path, buffers) abort
	let path = a:path
	let tmpfile = "/tmp/.tfind"

	if a:buffers
		let tmpfile_in = "/tmp/.tfind_in"
		let bufs = getbufinfo({ 'buflisted': 1 })
		call filter(bufs, { i, dict -> getbufvar(dict.bufnr, '&buftype') != 'terminal' })
		if !empty(path)
			call filter(bufs, { i, dict -> stridx(dict.name, path) >= 0 })
		endif
		call map(bufs, { i, dict -> dict.name })
		call writefile(bufs, tmpfile_in)
		let command = "tmenu >" . tmpfile . " <" .tmpfile_in
	else
		if empty(path)
			let path = s:lastpath
			if empty(path)
				let path = "."
			else
				echo "Using previous path: " . path
			endif
		else
			let s:lastpath = path
		endif
		let command = "find '" . path . "' -type f | tmenu >" . tmpfile
	endif

	if has("terminal")
		call s:tfind_term(command, tmpfile, a:editcmd, a:mods)
	else
		execute "silent !" . command
		redraw!
		call s:tfind_complete(tmpfile, a:editcmd, a:mods)
	endif
endfunction

command! -nargs=? -complete=dir Tedit call s:tfind("e", "<mods>", "<args>", 0)
command! -nargs=? -complete=dir Tsplit call s:tfind("sp", "<mods>", "<args>", 0)
command! -nargs=? -complete=dir Tvsplit call s:tfind("vs", "<mods>", "<args>", 0)

command! -nargs=? -complete=dir Tbuffer call s:tfind("e", "<mods>", "<args>", 1)
command! -nargs=? -complete=dir Tsbuffer call s:tfind("sp", "<mods>", "<args>", 1)
command! -nargs=? -complete=dir Tbvsbuffer call s:tfind("vs", "<mods>", "<args>", 1)
