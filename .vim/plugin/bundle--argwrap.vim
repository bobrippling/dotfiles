if !exists(":ArgWrap")
	finish
endif

nnoremap <silent> <leader>a :ArgWrap<CR>

let g:argwrap_padded_braces = "[{"

" disable for all, then enable for some
let g:argwrap_tail_comma = 0
let g:argwrap_tail_comma_braces = "[{"

augroup ArgWraps
	autocmd!

	" enable tail-comma for everything:
	autocmd FileType javascript
				\ let b:argwrap_tail_comma = 1 |
				\ let b:argwrap_tail_comma_braces = ""

augroup END
