" wrapper around :match
" :[N]Match[!] [word]
" N - nth match, like :2match
" ! - clear match
" word - match on word, rather than <cword>

highlight MatchBook0 ctermbg=darkmagenta ctermfg=black
highlight MatchBook1 ctermbg=darkcyan ctermfg=black
highlight MatchBook2 ctermbg=darkgreen ctermfg=white
highlight MatchBookX ctermbg=darkred ctermfg=white
let s:group_count = 3

let s:matches = []

function! MatchBook(clear, nth, keyword)
	if a:clear
		if !empty(keyword)
			throw "Can't clear with a keyword"
		endif

		if a:nth == 0
			for id in s:matches
				try
					call matchdelete(id)
				catch
				endtry
			endfor
			let s:matches = []
		else
			call matchdelete(s:matches[a:nth])
		endif
	else
		if a:nth != 0
			throw "Can't prescribe an id to match"
		endif

		let keyword = a:keyword
		if empty(keyword)
			let keyword = expand("<cword>")
		endif

		let i = len(s:matches)

		let group = i < s:group_count ? "MatchBook" . i : "MatchBookX"

		let id = matchadd(group, keyword)
		if id != -1
			let s:matches += [id]
		endif
	endif
endfunction

command -nargs=? -complete=tag -count -bang -bar MatchBook
\ call MatchBook(<bang>0, <count>, <q-args>)
