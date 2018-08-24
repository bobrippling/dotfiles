function! s:CAltFile()
	let expanded = expand("%:e")
	if expanded == "c" || expanded == "cpp"
		return expand("%:r") . ".h"
	else
		let target = expand("%:r") . ".cpp"
		if glob(target) != ""
			return target
		endif

		return expand("%:r") . ".c"
	endif
endfunction

function! s:JsSpecAlt()
	if expand("%:e:e:r") == "spec"
		return expand("%:r:r") . "." . expand("%:e")
	else
		return expand("%:r") . ".spec." . expand("%:e")
	endif
endfunction

function! AFileToggle(command)
	if &ft == "c" || &ft == "cpp"
		let alt = s:CAltFile()
	elseif &ft == "javascript"
		let alt = s:JsSpecAlt()
	else
		echohl Error
		echo "Can't handle filetype \"" . &ft . "\""
		return
	endif

	execute a:command . " " . alt
endfunction

command! A  call AFileToggle("edit")
command! AS call AFileToggle("split")
command! AV call AFileToggle("vsplit")
command! AT call AFileToggle("tabe")
