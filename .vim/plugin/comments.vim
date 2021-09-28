function! CommentsSetList()
	setl comments-=mb:* | setl comments+=mbn:*
	setl comments-=fb:- | setl comments+=n:-
endfunction

function! s:maybe_set_list()
	if !empty(&ft) && &ft !=# 'text'
		return
	endif
	call CommentsSetList()
endfunction

augroup Comments
	autocmd!

	autocmd BufNew,BufNewFile * call s:maybe_set_list()
augroup END
