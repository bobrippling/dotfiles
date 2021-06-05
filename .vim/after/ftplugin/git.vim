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
			\ | execute <mods> "new"
			\ | set filetype=git buftype=nofile
			\ | execute "r!git show" s:w
			\ | 1d

setlocal keywordprg=:GitShow
