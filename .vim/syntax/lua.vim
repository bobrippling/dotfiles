function! Luajumpblock(forward, do_gv) " {{{1
  let start = '\<\%(for\|function\|if\|repeat\|while\)\>'
  let middle = '\<\%(elseif\|else\)\>'
  let end = '\<\%(end\|until\)\>'
  let flags = a:forward ? '' : 'b'

	if a:do_gv
		normal gv
	endif

  call searchpair(start, middle, end, flags)
endfunction

setlocal formatoptions-=t formatoptions+=croql
setlocal commentstring=--%s
setlocal comments=s:--[[,m:\ ,e:]],:--

nnoremap <buffer> <silent> [{ m':call Luajumpblock(0, 0)<CR>
nnoremap <buffer> <silent> ]} m':call Luajumpblock(1, 0)<CR>
vnoremap <buffer> <silent> [{ m':call Luajumpblock(0, 1)<CR>
vnoremap <buffer> <silent> ]} m':call Luajumpblock(1, 1)<CR>

autocmd FileType lua nnoremap [[ ?^function\><CR>
autocmd FileType lua nnoremap ]] /^function\><CR>
