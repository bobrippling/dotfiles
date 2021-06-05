let s:root = "."

function! s:path() abort
	if v:count == 0
		return s:root
	endif

	return fnamemodify(getreg("%"), repeat(":h", v:count))
endfunction

nnoremap <silent> <expr> <leader>g ":<C-U>Bggrep '\\b\\b' " . <SID>path() . "<CR>"
nnoremap <silent> <expr> <leader>G ":<C-U>Bggrep '' " . <SID>path() . "<CR>"
