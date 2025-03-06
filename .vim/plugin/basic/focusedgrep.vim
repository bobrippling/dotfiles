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
	let search = escape(search, "%#")

	let type = qf#loc_list_open() ? "l" : ""

	" can't use ^R^W - this does a partial complete, so if we have "\b" and the
	" word starts with "b", it'll fill in the rest, e.g. "\buffer\b"
	"                                                       ^~~~~
	return ":\<C-U>Bg" . type . "grep " . search . " "
				\ . fileprops#dirname(v:count) . "\<CR>"
endfunction

function! s:bggrep_populate()
	if v:count == 0
		let dir = "."
	else
		" 1g/ --> Bggrep '<cursor>' %:h
		" 2g/ --> Bggrep '<cursor>' %:h:h
		let dir = "%" . repeat(":h", v:count)
	endif

	return ":\<C-U>Bggrep -i ' " . dir . repeat("\<Left>", len(dir) + 2) . "'"
endfunction

function! s:bggrep_curmove(cmdline, off)
  " move cursor between end-of-search-str and end-of-options (`-i`)
	try
		let [matched, start, end] = matchstrpos(a:cmdline, '\vBg\S+\s+\zs\S+\s*')
	catch /^E688/
		" no match
		return 0
	endtry
	if start is -1 && end is -1
		return 0
	endif
	let start += a:off
	let end += a:off

	let cursor = getcmdpos() - 1

	if matched !~ '^-'
		let post_cmd = match(matched, '\v\S+\zs\s')
		let post_cmd_idx = start + post_cmd

		" want to move the cursor to post_cmd_idx and insert the option hyphen
		return repeat("\<Left>", cursor - post_cmd_idx) . " -"
	endif

	if cursor >= end
		let s:save_cmdpos = cursor
		let whitespace = len(matchstr(matched, '\v\s+$'))
		return repeat("\<Left>", cursor - end + whitespace)
	else
		let saved = get(s:, 'save_cmdpos', -1)
		if saved == -1 || saved < cursor
			return
		endif
		return repeat("\<Right>", saved - cursor)
	endif
endfunction

nnoremap <silent> <expr> <leader>g <SID>bggrep_cmd(1)
nnoremap <silent> <expr> <leader>G <SID>bggrep_cmd(0)
nnoremap <silent> <expr> g<leader>g <SID>bggrep_cmd(2)

vnoremap g/ <Esc>'</\%V
nnoremap <expr> g/ <SID>bggrep_populate()

if !exists('g:ctrlb_handlers')
	let g:ctrlb_handlers = []
endif
if index(g:ctrlb_handlers, function('s:bggrep_curmove')) is -1
	let g:ctrlb_handlers += [function('s:bggrep_curmove')]
endif
