" disable "pi_c_k <hash>" K mapping jumping to the hash:
let g:no_gitrebase_maps = 1

" add our own:
command! -range=0 -bar -nargs=1 GitShow
			\ :<mods> new | <mods> term git show --format=fuller <args>

"command! -range=0 -bar -nargs=1 GitShow
"			\ :vnew\|set ft=git bt=nofile\|r!git show <C-R><C-W><CR>:1d<CR>

autocmd FileType git,gitrebase set keywordprg=:GitShow
