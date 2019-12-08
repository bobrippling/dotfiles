let g:netrw_banner = 0
let g:netrw_dirhistmax = 0

function! s:update_netrw_hide()
	let g:netrw_list_hide = netrw_gitignore#Hide()
endfunction

autocmd DirChanged * call s:update_netrw_hide()
call s:update_netrw_hide()
