let g:ctrlp_switch_buffer = 'e'
let g:ctrlp_working_path_mode = 'a'
" make this a dictionary with 'ignore' set, so ctrlp uses vim's 'wildignore' filtering
let g:ctrlp_user_command = {
	\ 'fallback': executable('rg')
	\   ? 'rg -l .'
	\   : 'find %s -type f -maxdepth 8 ! -ipath "*/.git/*" ! -ipath "*/node_modules/*"',
	\ 'ignore': 1,
	\ }
let g:ctrlp_max_height = 40
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](\.git|node_modules)$',
	\ 'file': '\v\.(exe|so|dll)$'
	\ }
