if has("gui")
	set guicursor+=a:blinkon0
	set guioptions+=gtcf
	set guioptions-=mi!aPATrRlLB

	set mouse=
	set visualbell t_vb=

	if has("gui_running")
		colorscheme relaxed
	endif
endif
