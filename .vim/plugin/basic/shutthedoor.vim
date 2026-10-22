" no -bar: that removes comments, so will prevent any double-quotes
command! -bang -nargs=* -complete=command ShutTheDoorOnYourWayOut call s:ShutTheDoorOnYourWayOut(<bang>0, <q-args>)

function! s:ShutTheDoorOnYourWayOut(wipe, cmd) abort
	let esccmd = escape(a:cmd, '"\')
	" BufWinLeave is still fired for :hide

	augroup ShutTheDoor
		execute 'autocmd BufUnload <buffer> ++once call s:ShutTheDoor(' . a:wipe . ', "' . esccmd . '")'
	augroup END

	" disable ShutTheDoor, if buf renamed
	autocmd BufFilePre <buffer> ++once call s:cancel()
endfunction

function! s:cancel() abort
	augroup ShutTheDoor
		autocmd! BufUnload <buffer=abuf>
	augroup END
	echom 'ShutTheDoor: disabled (buffer renamed)'
endfunction

function! s:ShutTheDoor(wipe, cmd) abort
	if !empty(a:cmd)
		execute a:cmd
		if !a:wipe
			" otherwise we're doing the command and deleting the buffer (+file)
			return
		endif
	endif

	let fname = expand("<afile>")
	if empty(fname)
		return
	endif

	if filereadable(fname)
		if delete(fname) != 0
			let msg = "Couldn't delete " . fname
		else
			let msg = "Deleted " . fname
		endif
	else
		let msg = "File not readable: " . fname
	endif

	if a:wipe
		" can't :bwipe in an autocmd for the buffer, so:
		call timer_start(1, { -> s:wipe(fname, msg) })
	else
		call s:show(msg)
	endif
endfunction

function! s:wipe(fname, msg)
	execute 'silent bwipeout' a:fname

	call s:show(a:msg . " (wiped out)")
endfunction

function! s:show(msg)
	echom a:msg
endfunction
