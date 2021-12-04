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

command! -range=0 -bar -nargs=1 GitShow
			\ let s:w = expand("<cWORD>")
			\ | execute empty(<q-mods>) ? "vnew" : <q-mods> "new"
			\ | set filetype=git buftype=nofile
			\ | nnoremap <buffer> <silent> q :q<CR>
			\ | execute "r!git show --format=fuller" s:w
			\ | 1d

setlocal keywordprg=:GitShow
