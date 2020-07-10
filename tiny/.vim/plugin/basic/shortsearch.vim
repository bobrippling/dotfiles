" Disable highlighting until we've entered a long search string.
"
" This helps for situations such as using vim over VNC/remote desktop, where
" highlighting all instances of 'e' or 'i' will chew up bandwidth for a
" second, only to remove the highlights when the next character is entered.

if !exists("g:shortsearch_enabled")
	let g:shortsearch_enabled = 0
endif
let s:save_hls = 0

function! s:cmdline_changed() abort
	" v:event.cmdtype
	if !g:shortsearch_enabled || getcmdtype() != "/"
		return
	endif

	let search = getcmdline()
	let &hlsearch = strlen(search) >= 3
endfunction

function! s:cmdline_enter()
	let s:save_hls = &hlsearch
endfunction

function! s:cmdline_leave()
	let &hlsearch = s:save_hls
endfunction

augroup ShortSearch
	autocmd!
	autocmd CmdlineEnter * call s:cmdline_enter()
	autocmd CmdlineChanged * call s:cmdline_changed()
	autocmd CmdlineLeave * call s:cmdline_leave()
augroup END
