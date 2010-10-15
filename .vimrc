" :cn - Goto the next error in source code.
" :cp - Goto the previous error in source code.
" ^Wv = split vertically
"
" set spell
" zg = add to dict
" z= = show list of suggestions
"
" [cdv][ai]X
" where X is one of: {[}]"'wsbBp
" s: sentence
" b: () block
" B: {} block
" p: paragraph

filetype on

if has("autocmd")
  filetype indent on
  filetype plugin on


  function! TrimSpaces()
    normal mZ
    %s/\s\+$//e
    if line("'Z") != line(".")
      echo "Stripped whitespace\n"
    endif
    normal `Z
  endfunction

  autocmd BufRead,BufNewFile *.s,asm,nasm set ft=nasm
  autocmd BufRead,BufNewFile *.go         set ft=go
  autocmd FileType c,cpp,slang            set cindent " c indentation > other two
  autocmd FileType Makefile               set noet

  autocmd BufWritePre *                   call TrimSpaces()
  " binding to turn off ^
  nnoremap <leader>w :autocmd! BufWritePre<CR>

  " when we reload, tell vim to restore the cursor to the saved position
  augroup JumpCursorOnEdit
   au!
    autocmd BufReadPost *
      \ if expand("<afile>:p:h") !=? $TEMP |
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \ let JumpCursorOnEdit_foo = line("'\"") |
      \ let b:doopenfold = 1 |
      \ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
      \ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
      \ let b:doopenfold = 2 |
      \ endif |
      \ exe JumpCursorOnEdit_foo |
      \ endif |
      \ endif
      " Need to postpone using "zv" until after reading the modelines.
      autocmd BufWinEnter *
      \ if exists("b:doopenfold") |
      \ exe "normal zv" |
      \ if(b:doopenfold > 1) |
      \ exe "+".1 |
      \ endif |
      \ unlet b:doopenfold |
      \ endif
      augroup END
endif

function! Wm()
	" :wq
	" :mak
	w
	mak
endfunction
nnoremap <leader>m :call Wm()<CR>

syntax on " syntax highlighting
set nocompatible " prevents vim emulating vi's bugs/limits
set guioptions=egLtcf
set number " line numbering
set nowrap " don't wrap lines
set sbr=^
set showmatch
set bs=indent,eol " allow backspacing over everything in insert mode
set incsearch
set showmatch " bracket matching
set matchpairs+=<:> " have % bounce between angled brackets, as well as t'other kinds:
set smartcase  " if search term has caps in, don't ignore case
set backspace=indent,eol,start " make backspace a more flexible
set noet
"set virtualedit=all " allow the cursor to roam anywhere
"set nomodeline
set laststatus=2
set showcmd
set scrolloff=5 " buffer zone at top and bottom
set cmdheight=1
set ttyfast
set wildmode=list:longest
set completeopt+=longest
set shortmess=filmnrwxtToO


"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=0x%02.2B]\ [POS=%04l/%L,%04v,%p%%]\
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%04v,%04l,%p%%]\ [LEN=%L]
set statusline=\ \%f%m%r%h%w\ ::\ %y[%{&ff}]\%=\ [%02v\ %p%%\ %l/%L]

"set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    + current
"              | | | | |  |   |      |  |     |       column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax in
"              | | | | |  |   |          square brackets
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- rodified flag in square brackets
"              +-- full path to file in the buffer

" set chars to show
"set listchars=tab:>-,trail:%
set listchars=tab:»·,trail:·
"set listchars=trail:·,tab:..
"set listchars=trail:·,tab:
set list



" Tell vim to remember certain things when we exit
"  '20 : marks will be remembered for up to X previously edited files
"  "100 : will save up to X lines for each register
"  :200 : up to X lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
set viminfo='20,\"100,:200,%,n~/.viminfo

"set et " expandtab - for tab <C-V><Tab>
set smarttab
set sw=2 " shiftwidth - >> and << adjustment
set tabstop=2
set nobackup
set ignorecase " searching

set foldlevel=256 " annoying

"set copyindent " buh
"set autoindent " indents to same as last line
set smartindent " uses c syntax etc to see where to indent to

let c_space_errors = 1


" Display - status line, etc
"if (&term =~ "-256color")
"	set t_Co=256
"else
	let CSApprox_loaded = 1
"endif
colorscheme neutral
" View colours:
" :runtime syntax/colortest.vim

" backslash + [tcl etc]
inoremap <leader>c <Esc>mpa/*<End>*/<Esc>`pl
nnoremap <leader>t :Tlist<CR>
nnoremap <leader>l :set list!<CR>
nnoremap <leader>h :set hls!<CR>
nnoremap <leader>x :r!xsel -o<CR>
nnoremap <leader>s s<Space><Esc>pa<Space><Esc>l
nnoremap <leader>W :set wrap!<CR>
nnoremap <tab>     >>
nnoremap <S-tab>   <<
" man page auto ret
nmap K K<cr>

" custom highlighting
"highlight MyTagListTagName   guifg=blue ctermfg=blue
"highlight MyTagListTagName   guifg=blue ctermfg=blue
"highlight MyTagListTagScope  guifg=blue ctermfg=blue
"highlight MyTagListTitle     guifg=blue ctermfg=blue
"highlight MyTagListComment   guifg=blue ctermfg=blue
"highlight MyTagListFileName  guifg=blue ctermfg=blue

" move up/down without changing cursor pos
nnoremap <C-Y>    3<C-Y>
nnoremap <C-E>    3<C-E>

" Side scrolling
"nnoremap zh 4zh
"nnoremap zh 4zl

"vmap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
