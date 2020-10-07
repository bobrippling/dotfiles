let s:nsearches = 0

function! SearchIgnSyn(dir, restore_visual) abort
	let [startbuf, startline, startcol, startoff, startcurswant] = getcurpos()

	if a:restore_visual
		normal! gv
	endif

	" FIXME: do this v:count[1] times?

	while v:true
		try
			execute "normal!" a:dir
		catch /^Vim.*E38[45]/
			" not found, hit start/end
			echohl ErrorMsg
			echo v:exception
			echohl None
			break
		endtry

		let [buf, line, col, off, curswant] = getcurpos()
		let syn = synIDattr(synID(line, col, 0), "name")
		if syn !~? "comment"
			break
		endif

		let [endbuf, endline, endcol, endoff, endcurswant] = getcurpos()
		" wrapped round to the beginning?
		if endline == startline && endcol == startcol
			break
		endif
	endwhile
endfunction

function! s:cmdline_leave()
	if getcmdtype() != "/"
		return
	endif

	let s:nsearches += 1
	if s:nsearches >= 2
		call s:maps(0)
	endif
endfunction

function! s:maps(enable)
	if a:enable
		" can't use s:... in mappings
		nmap <silent> n :call SearchIgnSyn("n", 0)<CR>
		nmap <silent> N :call SearchIgnSyn("N", 0)<CR>
		vmap <silent> n :<C-U>call SearchIgnSyn("n", 1)<CR>
		vmap <silent> N :<C-U>call SearchIgnSyn("N", 1)<CR>
	else
		nunmap n
		nunmap N
		vunmap n
		vunmap N
	endif

	augroup SearchIgnoreSyn
		autocmd!
		if a:enable
			autocmd CmdlineLeave * call s:cmdline_leave()
			let s:nsearches = 0
		endif
	augroup END
endfunction

command! SearchIgnoreComments call s:maps(1)
