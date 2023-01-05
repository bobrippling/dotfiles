let s:root = "."

function! s:bggrep_cmd(mode)
	if a:mode == 0
		let search = expand("<cword>")
	elseif a:mode == 1
		let boundary = '\b'
		let search = boundary . expand("<cword>") . boundary
	elseif a:mode == 2
		let search = substitute(@/, '\\<\|\\>', '\\b', 'g')
	endif

	let search = shellescape(search)

	let type = qf#loc_list_open() ? "l" : ""

	" can't use ^R^W - this does a partial complete, so if we have "\b" and the
	" word starts with "b", it'll fill in the rest, e.g. "\buffer\b"
	"                                                       ^~~~~
	return ":\<C-U>Bg" . type . "grep " . search . " "
				\ . fileprops#dirname(v:count) . "\<CR>"
endfunction

nnoremap <silent> <expr> <leader>g <SID>bggrep_cmd(1)
nnoremap <silent> <expr> <leader>G <SID>bggrep_cmd(0)
nnoremap <silent> <expr> g<leader>g <SID>bggrep_cmd(2)
