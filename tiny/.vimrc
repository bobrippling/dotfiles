set nocompatible

" movement
set matchpairs+=<:>
set virtualedit=all
set tildeop

" search
set ignorecase smartcase
set nowrapscan
set incsearch

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

" display
set noequalalways
set novisualbell
set scrolloff=1
set sidescroll=1
set splitbelow splitright
set wildmode=list:longest
set statusline=\ \%f%m%r%h%w\ %y[%{&ff}][%n]%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}%=\ [%l/%L]
set laststatus=2
set showcmd
set shortmess=aoOTIt
set diffopt+=vertical
set tabstop=2 shiftwidth=2 noexpandtab
set history=400

" editing
set cindent
set cinoptions+=j1,J1,l1,N-s,t0
set formatoptions+=clnoqrt
if v:version >= 704
	set formatoptions+=j
endif

let g:netrw_banner = 0
let g:netrw_dirhistmax = 0

nmap <silent> <leader>n :cn<CR>
nmap <silent> <leader>N :w\|cn<CR>
nmap <silent> <leader>j :n<CR>
nmap <silent> <leader>J :w\|n<CR>
nmap <silent> <leader>h :set hls!<CR>
nmap <silent> <leader>g :grep <CR>
nmap <silent> <leader>G :grep '\b\b'<CR>
nmap <silent> <leader>* :match IncSearch /\<\>/<CR>
nmap <silent> <leader>l :set list!<CR>
nmap <silent> <leader>w :set wrap!<CR>
nmap <silent> <leader>S :set spell!<CR>
nmap <silent> <leader>f :let @" = bufname("%")<CR>
nmap <silent> <leader>F :let @" = expand("%:p")<CR>
nmap <silent> <leader>M :set modifiable!<CR>
nmap <silent> <leader>m :update\|make<CR>
nmap <silent> <leader>a :vertical ball<CR>

nmap <silent> ZW :w<CR>
nmap <silent> ZE :e<CR>

nmap <silent> [% :call searchpair('\[', '', '\]', 'Wb')<CR>
nmap <silent> ]% :call searchpair('\[', '', '\]', 'W')<CR>
nmap <silent> [< :call searchpair('<', '', '>', 'Wb')<CR>
nmap <silent> ]> :call searchpair('<', '', '>', 'W')<CR>

nnoremap ' `
nnoremap <C-Y> 3<C-Y>
nnoremap <C-E> 3<C-E>
nnoremap Y y$
nnoremap gt :<C-U>exec 'normal ' . repeat("gT", tabpagenr("$") - v:count1)<CR>
nmap g<CR> gjg^
nmap <C-W>gD <C-W>sgD

function Joinoperator(submode)
	normal $mj
	'[,']join
	normal 'jl
endfunction
nnoremap J :silent set operatorfunc=Joinoperator<CR>g@
set nojoinspaces

if has("terminal")
	tnoremap <C-W><C-W> <C-W>.
	tnoremap <C-W>gT <C-W>:tabp<CR>
	tnoremap <C-W>gt <C-W>:tabn<CR>
	cabbrev vter vert term
endif

if has("gui_running")
	set guicursor+=a:blinkon0
	set guioptions+=gtcf
	set guioptions-=mi!aPATrRlLB
endif

syntax on
filetype on
filetype indent plugin on

colorscheme grb256

if exepath("ag") != ""
	set grepprg=ag\ --depth\ 6\ --ignore\ \"_[^_]\*\"\ --ignore\ \"\*.o\"\ --ignore\ \"\*.d\"\ --ignore\ \"node_modules\"\ --ignore\ \"\*.min.\*\"
endif

execute pathogen#infect()

let g:ctrlp_switch_buffer = ''
let g:ctrlp_working_path_mode = ''
let g:ctrlp_user_command = 'find %s -type f -maxdepth 8 ! -ipath "*/.git/*" ! -ipath "*/node_modules/*"'
let g:ctrlp_max_height = 40
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](\.git|node_modules)$',
	\ 'file': '\v\.(exe|so|dll)$'
	\ }

let g:Blockwise_default_mapping = 0

let g:grepper = { 'open': 0 }
