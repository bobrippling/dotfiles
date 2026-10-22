if has('win32')
	if executable('grep')
		let &grepprg = 'grep -HInr $*'
	endif

	if executable('bash')
		set shell=bash
		set shellcmdflag=-c
	endif

	set shellslash
endif
