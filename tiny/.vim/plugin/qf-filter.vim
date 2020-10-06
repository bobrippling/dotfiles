function! s:Filter(pattern, reject, range_count, range_start, range_end) abort
	let pattern = a:pattern
	if a:range_count > 0
		let title = printf("%d,%dQF%s", a:range_start, a:range_end, (a:reject ? "Drop" : "Keep"))

		if !empty(pattern)
			throw "Can't filter to a range and pattern"
		endif

		let [range_start, range_end] = [a:range_start, a:range_end]
		function! s:FilterRange(i, dict) abort closure
			let i = a:i + 1 " 0 based index -> 1 based line number
			return range_start <= i && i <= range_end
		endfunction

		let Iter = function('s:FilterRange')
	else
		let title = printf("QF%s %s", (a:reject ? "Drop" : "Keep"), pattern)

		let without_re = substitute(pattern, "-re ", "", "")
		let is_re = without_re !=# pattern
		let pattern = without_re
		let Matcher = is_re ? function('match') : function('stridx')

		let file = substitute(pattern, "\\v-f%[ile] ", "", "")
		if file !=# pattern
			function! s:FilterFile(i, dict) abort closure
				return Matcher(bufname(a:dict.bufnr), file) >= 0
			endfunction

			let Iter = function('s:FilterFile')
		else
			let text = substitute(pattern, "\\v(-t%[ext] )?", "", "")
			function! s:FilterText(i, dict) abort closure
				return Matcher(a:dict.text, text) >= 0
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

	" 'r': replace, ' ': push
	let flags = " "
	if have_open_loclist
		let idx = getloclist(0, {'idx': 0}).idx
		call setloclist(0, [], flags, {
		\   'items': filter(getloclist(0), Iter),
		\   'idx': idx,
		\   'title': title,
		\ })
	else
		let idx = getqflist({'idx': 0}).idx
		call setqflist([], flags, {
		\   'items': filter(getqflist(), Iter),
		\   'idx': idx,
		\   'title': title,
		\ })
	endif
endfunction

" QFKeep [-re] -f[ile] <file>       - keep (or drop) entries where the file matches file-re
" QFKeep [-re] [-t[ext]] <text>     - keep (or drop) entries where the text matches text-re
" a,b QFKeep                  - keep (or drop) entries in range a...b

command! -range -nargs=* QFKeep call s:Filter(<q-args>, 0, <range>, <line1>, <line2>)
command! -range -nargs=* QFDrop call s:Filter(<q-args>, 1, <range>, <line1>, <line2>)

" alternative dist package:
if 0 && exists(":packadd")
	packadd cfilter
endif
