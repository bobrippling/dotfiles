command! -bang -bar ShutTheDoorOnYourWayOut call s:ShutTheDoorOnYourWayOut(<bang>0)

function! s:ShutTheDoorOnYourWayOut(wipe) abort
	" BufWinLeave is still fired for :hide
	execute 'autocmd BufUnload <buffer> ++once call s:ShutTheDoor(' . a:wipe . ')'
endfunction

function! s:ShutTheDoor(wipe) abort
	let buf = expand("<afile>")
	if empty(buf)
		return
	endif


	if filereadable(buf)
		if delete(buf) != 0
			let msg = "Couldn't delete " . buf
		else
			let msg = "Deleted " . buf
		endif
	else
		let msg = "File not readable: " . buf
	endif

	if a:wipe
		" can't :bwipe in an autocmd for the buffer, so:
		call timer_start(1, { -> s:wipe(buf, msg) })
	else
		call s:show(msg)
	endif
endfunction

function! s:wipe(buf, msg)
	execute 'silent bwipeout' a:buf

	call s:show(a:msg . " (wiped out)")
endfunction

function! s:show(msg)
	echom a:msg
endfunction
