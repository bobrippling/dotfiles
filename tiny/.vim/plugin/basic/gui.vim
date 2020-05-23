if has("gui")
	set guicursor+=a:blinkon0
	set guioptions+=gtcf
	set guioptions-=mi!aPATrRlLB

	set mouse=
	set visualbell t_vb=

	if has("gui_running")
		try
			colorscheme relaxed
		catch /E185/
		endtry
	endif
endif
