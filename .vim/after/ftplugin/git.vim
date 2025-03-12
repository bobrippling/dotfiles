"if has("nvim")
"	command! -range=0 -bar -nargs=1 GitShow
"				\ <mods> new
"				\ | execute "term git show --format=fuller <args>"
"				\ | startinsert
"else
"	command! -range=0 -bar -nargs=1 GitShow
"				\ execute <mods> "term git show --format=fuller <args>"
"				\ | startinsert
"endif

if !exists('s:in')
	let s:in = 0
endif

if !s:in
	function! s:Show(mods, args)
		execute empty(a:mods) ? "vnew" : a:mods .. "new"

		let s:in = 1
		try
			set filetype=git buftype=nofile
		finally
			let s:in = 0
		endtry
		nnoremap <buffer> <silent> q :q<CR>

		execute "r!git show --format=fuller" a:args
		1d_
	endfunction

	function! s:Keyword(mods)
		let line = getline('.')
		let ci = substitute(line, '\v\S+ ([0-9a-f]+) .*', '\1', '')

		let args = v:count == 1 ? "-w " : ""

		call s:Show(a:mods, args .. ci)
	endfunction

	command! -bar -nargs=1 -count GitKeyword call s:Keyword(<q-mods>)
	command! -bar -nargs=+ GitShow call s:Show(<q-mods>, <q-args>)
endif

try
	nunmap <buffer> K
catch //
endtry

setlocal keywordprg=:GitKeyword
setlocal foldmethod=syntax
