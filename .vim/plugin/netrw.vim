let g:netrw_banner = 0
let g:netrw_dirhistmax = 0

function! s:update_netrw_hide()
	if cwdprops#in_network_mount()
		"echom "not updating netrw - in network filesystem"
		return
	endif

	if !exists("*netrw_gitignore#Hide")
		return
	endif
	let g:netrw_list_hide = netrw_gitignore#Hide()
	echom "netrw hide list updated from gitignore"
endfunction

if exists("#DirChanged")
	autocmd DirChanged * call s:update_netrw_hide()
endif
call s:update_netrw_hide()
