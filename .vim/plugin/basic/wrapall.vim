function! WrapAll()
	let wrapped = 0
	let unwrapped = 0
	for i in range(1, winnr("$"))
		if getwinvar(i, "&wrap")
			let wrapped += 1
		else
			let unwrapped += 1
		endif
	endfor

	if wrapped == 0
		let all = 1
	elseif unwrapped == 0
		let all = 0
	else
		let all = &l:wrap
	endif

	for i in range(1, winnr("$"))
		call setwinvar(i, "&wrap", all)
	endfor
endfunction

nnoremap <silent> <leader>W :<C-U>call WrapAll()<CR>
