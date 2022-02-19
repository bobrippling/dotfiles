" Like surround / builtin `ci(` operators, but jump to next bracket pair, not
" the one we're in.
"
" Can't use `n(` - this stops `Jn` for example (collides with builtin `n`)
" inspired from wellle/targets

finish " slow

for [open, close] in [
	\ ['(', ')'],
	\ ['{', '}'],
	\ ['[', ']'],
	\ ['<', '>'],
	\ ['"', '"'],
	\ ["'", "'"],
	\ ]

	" map `in(` to "in next paren"
	" map `iN(` to "in previous paren"
	" (can't use `ip(` because it conflicts with paragraph textobjs)

	for in_around in ['i', 'a']
		execute "onoremap " . in_around . "n" . open . " <Cmd>normal! f" . open . "v" . in_around . open . "<CR>"
		execute "onoremap " . in_around . "N" . open . " <Cmd>normal! F" . close . "v" . in_around . open . "<CR>"
	endfor
endfor
