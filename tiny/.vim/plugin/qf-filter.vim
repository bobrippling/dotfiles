function! s:Filter(pattern, reject, range_count, range_start, range_end) abort
	if a:range_count > 0
		if !empty(a:pattern)
			throw "Can't filter to a range and pattern"
		endif

		let [range_start, range_end] = [a:range_start, a:range_end]
		function! s:FilterRange(i, dict) abort closure
			let i = a:i + 1 " 0 based index -> 1 based line number
			return range_start <= i && i <= range_end
		endfunction

		let Iter = function('s:FilterRange')
	else
		let file = substitute(a:pattern, "\\v^-f%[ile] ", "", "")
		if file !=# a:pattern
			function! s:FilterFile(i, dict) abort closure
				return stridx(bufname(a:dict.bufnr), file) >= 0
			endfunction

			let Iter = function('s:FilterFile')
		else
			let text = substitute(a:pattern, "\\v^(-t%[ext] )?", "", "")
			function! s:FilterText(i, dict) abort closure
				return stridx(a:dict.text, text) >= 0
			endfunction

			let Iter = function('s:FilterText')
		endif
	endif

	if a:reject
		let Prev_filter = Iter
		function! s:Invert(...) abort closure
			return !function(Prev_filter, a:000)()
		endfunction
		let Iter = function('s:Invert')
	endif

	let loclist_winid = get(getloclist(0, { 'winid': 0 }), 'winid', 0)
	let have_open_loclist = loclist_winid != 0

	let flags = "r" " or ' ' to push onto :chist
	if have_open_loclist
		call setloclist(0, filter(getloclist(0), Iter), flags)
	else
		call setqflist(filter(getqflist(), Iter), flags)
	endif
endfunction

" QFKeep -f[ile] <file-re>       - keep (or drop) entries where the file matches file-re
" QFKeep [-t[ext]] <text-re>     - keep (or drop) entries where the text matches text-re
" a,b QFKeep                     - keep (or drop) entries in range a...b

command! -range -nargs=* QFKeep call s:Filter(<q-args>, 0, <range>, <line1>, <line2>)
command! -range -nargs=* QFDrop call s:Filter(<q-args>, 1, <range>, <line1>, <line2>)

" alternative dist package:
if 0 && exists(":packadd")
	packadd cfilter
endif
