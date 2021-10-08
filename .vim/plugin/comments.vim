function! s:set()
	setl comments-=mb:* | setl comments+=mbn:*
	setl comments-=fb:- | setl comments+=n:-
endfunction

function! s:maybe_set_list()
	if !empty(&ft) && &ft !=# 'text'
		return
	endif
	call s:set()
endfunction

command! -bar CommentList call s:set()

augroup Comments
	autocmd!

	autocmd BufNew,BufNewFile * call s:maybe_set_list()
augroup END
