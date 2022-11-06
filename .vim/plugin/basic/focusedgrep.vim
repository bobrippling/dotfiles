let s:root = "."

function! s:bggrep_cmd(word_boundary)
	let boundary = ""
	if a:word_boundary
		let boundary = '\b'
	endif

	let type = qf#loc_list_open() ? "l" : ""

	" can't use ^R^W - this does a partial complete, so if we have "\b" and the
	" word starts with "b", it'll fill in the rest, e.g. "\buffer\b"
	"                                                       ^~~~~
	return ":\<C-U>Bg" . type . "grep '"
				\ . boundary . expand("<cword>") . boundary . "' "
				\ . fileprops#dirname(v:count) . "\<CR>"
endfunction

nnoremap <silent> <expr> <leader>g <SID>bggrep_cmd(1)
nnoremap <silent> <expr> <leader>G <SID>bggrep_cmd(0)
