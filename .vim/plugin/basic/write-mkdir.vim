function! s:wmkdir(path)
	try
		w ++p
		return
	catch /E474:/
		" unsupported, fallback to below
	endtry

	let dir = a:path
	if empty(dir)
		let dir = expand("%")
	endif
	let dir = fnamemodify(dir, ":h")
	let r = mkdir(dir, "p")

	if r == v:false
		echoerr "Couldn't create" dir
	endif

	execute "w" a:path
endfunction

command! -bar -nargs=? -complete=file Wmkdir call s:wmkdir(<q-args>)
