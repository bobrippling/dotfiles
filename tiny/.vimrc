set nocompatible

" movement
set matchpairs+=<:>
set virtualedit=all
set tildeop

" search
set ignorecase smartcase
set nowrapscan
set incsearch
set tagcase=match
set hlsearch

" line wrapping
set nowrap
set linebreak showbreak=>
if exists("&breakindent")
	set breakindent
endif

" os/files
set clipboard=
set undofile
set undodir=~/.vim/undo
set cpoptions+=i
set fileencodings+=utf-16le
set sessionoptions-=options | set sessionoptions+=localoptions
set wildignore=*.o,*.d
set nomodeline
set directory=.

" display
" ('statusline' set in plugin/...)
set noequalalways
set novisualbell
set scrolloff=1
set sidescroll=1
set splitbelow splitright
set wildmode=list:longest,full
set wildmenu
set wildignorecase
set laststatus=2
set showcmd
set shortmess=aoOTIt
set diffopt+=vertical
set tabstop=2 shiftwidth=0 noexpandtab
set history=2000
set lazyredraw
set foldopen-=block
set completeopt+=menuone,noselect

" display (gui)
" m: menu bar
" M: don't source menu.vim
" T: toolbar
" r: right hand scrollbar
" L: left hand scrollbar when split
set go-=m go+=M go-=T go-=r go-=L


" editing
set cindent
set cinoptions+=j1,J1,l1,N-s,t0
set formatoptions+=clnoqrt
if v:version >= 704
	set formatoptions+=j
endif

" terminal
set notimeout ttimeout " timeout on keycodes only, wait forever for mappings

if has("nvim")
	set inccommand=split
endif

nnoremap <expr> <silent> <leader>j ":<C-U>" . v:count1 . "n<CR>"
nnoremap <expr> <silent> <leader>J ":<C-U>" . v:count1 . "w\\|n<CR>"
nnoremap <expr> <silent> <leader>t ":<C-U>" . v:count1 . "tabn<CR>"
nnoremap <silent> <leader>h :noh<CR>
nnoremap <silent> <leader>H :set hls!<CR>
nnoremap <silent> <leader>g :grep <CR>
nnoremap <silent> <leader>G :grep '\b\b'<CR>
nnoremap <silent> <leader>* :match IncSearch /\<\>/<CR>
nnoremap <silent> <leader>l :set list!<CR>
nnoremap <silent> <leader>w :set wrap!<CR>
nnoremap <silent> <leader>S :set spell!<CR>
nnoremap <silent> <leader>f :let @" = bufname("%")<CR>
nnoremap <silent> <leader>F :let @" = expand("%:p")<CR>
nnoremap <silent> <leader>M :set modifiable!<CR>
nnoremap <silent> <leader>m :update\|make<CR>
nnoremap <silent> <leader>a :vertical ball<CR>
nnoremap gS :echo synIDattr(synID(getcurpos()[1], getcurpos()[2], 0), "name")<CR>

nnoremap <silent> ZW :w<CR>
nnoremap <silent> ZE :e<CR>
nnoremap <silent> <C-W>N :vnew<CR>

nnoremap ' `
nnoremap <C-Y> 3<C-Y>
nnoremap <C-E> 3<C-E>
nnoremap Y y$
nnoremap <silent> gt :<C-U>exec 'normal ' . repeat("gT", tabpagenr("$") - v:count1)<CR>
nnoremap <silent> <C-W>2T <C-W>T:tabm-1<CR>
nmap g<CR> gjg^
nmap <C-W>gD <C-W>sgD

" available <C-W> mappings: aeuy (g is taken by tradewinds plugin)
nnoremap <silent> <C-W>y :set winfixheight!<CR>
nnoremap <silent> <C-W>u :set winfixwidth!<CR>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

vnoremap g/ <Esc>'</\%V

syntax on
filetype on
filetype indent plugin on

colorscheme ir_black

if has("nvim")
	highlight TermCursorNC ctermfg=15 ctermbg=14 cterm=none
else
	" change cursor shape on insert
	let &t_SI = "\e[6 q"
	let &t_SR = "\e[4 q"
	let &t_EI = "\e[2 q"

	" don't let vim change cursor color:
	set t_SC=
	set t_EC=
endif

execute pathogen#infect()

" vim runtime settings
" disable python tab settings
let g:python_recommended_style = 0

let g:ctrlp_switch_buffer = ''
let g:ctrlp_working_path_mode = ''
" make this a dictionary with 'ignore' set, so ctrlp uses vim's 'wildignore' filtering
let g:ctrlp_user_command = {
\ 'fallback': 'find %s -type f -maxdepth 8 ! -ipath "*/.git/*" ! -ipath "*/node_modules/*"',
\ 'ignore': 1,
\ }
let g:ctrlp_max_height = 40
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](\.git|node_modules)$',
	\ 'file': '\v\.(exe|so|dll)$'
	\ }

let g:Blockwise_default_mapping = 0

let g:grepper = { 'open': 0 }

let g:Blockwise_default_mapping = 0

let g:Illuminate_delay = 0
let g:Illuminate_ftblacklist = []

" -: leap, r: remote, p: place, u: remote-outer, o: place-outer
let g:seek_noignorecase = 1
let g:seek_enable_jumps = 1
let g:SeekKey = '-'
let g:SeekBackKey = '_'
