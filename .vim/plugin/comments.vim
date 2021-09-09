function! s:bufinit()
	setl comments-=mb:* | setl comments+=mbn:*
	setl comments-=fb:- | setl comments+=n:-
endfunction

augroup Comments
	autocmd!

	autocmd BufNew,BufNewFile * call s:bufinit()
augroup END
