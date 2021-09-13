function! CommentsSetList()
	if !empty(&ft)
		return
	endif

	setl comments-=mb:* | setl comments+=mbn:*
	setl comments-=fb:- | setl comments+=n:-
endfunction

augroup Comments
	autocmd!

	autocmd BufNew,BufNewFile * call CommentsSetList()
augroup END
