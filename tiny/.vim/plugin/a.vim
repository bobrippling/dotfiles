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

function! s:SpecAlt()
	if expand("%:e:e:r") == "spec"
		return expand("%:r:r") . "." . expand("%:e")
	else
		return expand("%:r") . ".spec." . expand("%:e")
	endif
endfunction

function! AFileToggle(command, mods)
	if &ft == "c" || &ft == "cpp"
		let alt = s:CAltFile()
	elseif &ft == "javascript" || &ft == "python" || &ft == "ruby"
		let alt = s:SpecAlt()
	else
		echohl Error
		echo "Can't handle filetype \"" . &ft . "\""
		return
	endif

	execute a:mods . " " . a:command . " " . alt
endfunction

command! A  call AFileToggle("edit", <q-mods>)
command! AS call AFileToggle("split", <q-mods>)
command! AV call AFileToggle("vsplit", <q-mods>)
command! AT call AFileToggle("tabe", <q-mods>)
