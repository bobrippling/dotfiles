" :sp - new window above
" :vs -  "     "   left
"
" :cn - Goto the next error in source code.
" :cp - Goto the previous error in source code.

set nocompatible " prevents vim emulating vi's bugs/limits

filetype on

if has("autocmd")
  filetype indent on
  filetype plugin on

  autocmd FileType c             set formatoptions+=ro
  autocmd FileType c,cpp,slang   set cindent " c indentation > other two
  autocmd FileType Makefile      set noet
  autocmd FileType *.s,asm,nasm  set syntax=nasm

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

syntax on " syntax highlighting
set number " line numbering
set nowrap " don't wrap lines
set bs=indent,eol " allow backspacing over everything in insert mode
set incsearch
set showmatch " bracket matching
set matchpairs+=<:> " have % bounce between angled brackets, as well as t'other kinds:
set smartcase  " if search term has caps in, don't ignore case
set backspace=indent,eol,start " make backspace a more flexible
"set virtualedit=all " allow the cursor to roam anywhere
"set nomodeline
set laststatus=2
set showcmd
set scrolloff=5 " buffer zone at top and bottom
set cmdheight=1

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
set list!


" Tell vim to remember certain things when we exit
"  '20 : marks will be remembered for up to X previously edited files
"  "100 : will save up to X lines for each register
"  :200 : up to X lines of command-line history will be remembered
"  % : saves and restores the buffer list
"  n... : where to save the viminfo files
set viminfo='20,\"100,:200,%,n~/.viminfo

set et " expandtab - for tab <C-V><Tab>
set smarttab
set sw=2 " shiftwidth - >> and << adjustment
set shiftwidth=2 " general width of indents
set tabstop=2
set nobackup
set ignorecase " searching

"set copyindent " buh
"set autoindent " indents to same as last line
set smartindent " uses c syntax etc to see where to indent to

let c_space_errors = 0


" Display - status line, etc
colorscheme neutral
" View colours:
" :runtime syntax/colortest.vim

" Rebind S to work as the opposite as J (join lines) - split lines
nnoremap S i<CR><Esc>

" C commenting
inoremap <F3> /*<End>*/<Esc>^i

" bind tN to new tab, tn to next tab and tp to prev tab
"nnoremap tT :tabnew<CR>
"nnoremap tn :tabnext<CR><CR>
"nnoremap tp :tabprev<CR>
"nnoremap tT :tabclose<CR>

nnoremap <F4> :Tlist<CR>
" custom highlighting
"highlight MyTagListTagName   guifg=blue ctermfg=blue
"highlight MyTagListTagName   guifg=blue ctermfg=blue
"highlight MyTagListTagScope  guifg=blue ctermfg=blue
"highlight MyTagListTitle     guifg=blue ctermfg=blue
"highlight MyTagListComment   guifg=blue ctermfg=blue
"highlight MyTagListFileName  guifg=blue ctermfg=blue


" Alt+J/K
"nnoremap k 3k
"nnoremap j 3j

" move up/down without changing cursor pos
nnoremap <C-Y>    3<C-Y>
nnoremap <C-E>    3<C-E>

" Side scrolling
"nnoremap zh 4zh
"nnoremap zh 4zl

"vmap <C-c> y:call system("xclip -i -selection clipboard", getreg("\""))<CR>:call system("xclip -i", getreg("\""))<CR>
