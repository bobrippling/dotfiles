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
	augroup NetRwGit
		autocmd!
		autocmd DirChanged * call s:update_netrw_hide()

		" queue for post-startup, to avoid lag
		autocmd VimEnter * call s:update_netrw_hide()
	augroup END
endif

function! s:set()
	vnoremap mf :normal mf<CR>
	"                  ^ no !, need the netrw mapping
endfunction

augroup NetRwMap
	autocmd!
	autocmd FileType netrw call s:set()
augroup END
