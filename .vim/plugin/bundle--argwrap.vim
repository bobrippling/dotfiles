if !rtp#exists("vim-argwrap")
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

	autocmd FileType c
				\ let b:argwrap_wrap_closing_brace = 0

	autocmd FileType json
				\ let b:argwrap_tail_comma = 0 |
				\ let b:argwrap_tail_comma_braces = ""

	autocmd FileType vim
				\ let b:argwrap_line_prefix = '\ '
augroup END
