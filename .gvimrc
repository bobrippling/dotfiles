set background=dark
set ic
set scs
set nowrap
set sbr=^
set sm
set tabstop=2
set shiftwidth=2
set softtabstop=2
set sta
set et
set ai
set si
set nu

set guicursor+=a:blinkon0
set guioptions=egLt " add m for menu, T for toolbar, r for right scoll bar

colorscheme molokai

if has("gui_running")
    set guifont=profont
    "set guifont=ProggyTinyTT:h11:cANSI
    set lines=50
    set columns=160
    set guioptions=cegrLt
endif

filetype plugin indent on
