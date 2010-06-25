set background=dark
set guicursor+=a:blinkon0
set guioptions=egtcf " already set in .vimrc (need to for 'f')
" e: tab pages, g: grey menu items, L: lhs scrollbar, t: 'tearoff' menu items
" c: console dialogues, f: foreground
" add m for menu, T for toolbar, r for right scoll bar

colorscheme molokai

if has("gui_running")
	set guifont=profont
	"set guifont=ProggyTinyTT:h11:cANSI
	set lines=50
	set columns=160
endif

filetype plugin indent on
