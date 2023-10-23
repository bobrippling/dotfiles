command! -bar ShutTheDoorOnYourWayOut call s:ShutTheDoorOnYourWayOut()

function! s:ShutTheDoorOnYourWayOut() abort
	" BufWinLeave is still fired for :hide
	autocmd BufUnload <buffer> ++once call s:ShutTheDoor()
endfunction

function! s:ShutTheDoor() abort
	let buf = expand("<afile>")
	if empty(buf)
		return
	endif
	if !filereadable(buf)
		echom "File not readable:" buf
		return
	endif

	if delete(buf) != 0
		echoerr "Couldn't delete" buf
	else
		echom "Deleted" buf
	endif
endfunction
