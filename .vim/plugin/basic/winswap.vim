function! WSwap(target_win) abort
	let current_win = winnr()
	let current_buf = bufnr('')

	execute a:target_win . 'wincmd w'
	let target_buf = bufnr('')

	execute 'hide b ' . current_buf
	execute 'wincmd p'
	execute 'b ' . target_buf
endfunction

command! -bar -addr=windows -nargs=? WSwap call WSwap(empty(<q-args>) ? <line1> : <q-args>)
