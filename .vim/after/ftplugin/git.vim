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
	function! s:K(mods)
		let line = getline('.')
		let ci = substitute(line, '\v\S+ ([0-9a-f]+) .*', '\1', '')

		execute empty(a:mods) ? "vnew" : a:mods .. "new"

		let s:in = 1
		try
			set filetype=git buftype=nofile
		finally
			let s:in = 0
		endtry
		nnoremap <buffer> <silent> q :q<CR>

		execute "r!git show --format=fuller" ci
		1d_
	endfunction

	command! -range=0 -bar -nargs=1 GitShow call s:K(<q-mods>)
endif

try
	nunmap <buffer> K
catch //
endtry

setlocal keywordprg=:GitShow
