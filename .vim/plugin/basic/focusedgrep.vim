let s:root = "."

function! s:bggrep_cmd(word_boundary)
	let boundary = ""
	if a:word_boundary
		if stridx(&grepprg, '$*')
			" need to double escape to get past shell expansion of 'grepprg'
			let boundary = '\\b'
		else
			let boundary = '\b'
		endif
	endif

	let type = qf#loc_list_open() ? "l" : ""

	return ":\<C-U>Bg" . type . "grep '"
				\ . boundary . "" . boundary . "' "
				\ . fileprops#dirname(v:count) . "\<CR>"
endfunction

nnoremap <silent> <expr> <leader>g <SID>bggrep_cmd(1)
nnoremap <silent> <expr> <leader>G <SID>bggrep_cmd(0)
