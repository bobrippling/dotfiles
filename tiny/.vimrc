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
set linebreak breakindent showbreak=>

" os/files
set clipboard=
set undofile
set undodir=~/.vim/undo
set cpoptions+=i

" display
set noequalalways
set novisualbell
set scrolloff=1
set splitbelow splitright
set wildmode=list:longest
set cindent
set statusline=\ \%f%m%r%h%w\ %y[%{&ff}][%n]%=\ [%p%%]
set laststatus=1
set showcmd
set shortmess=aoOTIt
set diffopt+=vertical

let g:netrw_banner = 0

nmap <silent> <leader>n :cn<CR>
nmap <silent> <leader>N :w\|cn<CR>
nmap <silent> <leader>j :n<CR>
nmap <silent> <leader>J :w\|n<CR>
nmap <silent> <leader>h :set hls!<CR>
nmap <silent> <leader>g :grep <CR>
nmap <silent> <leader>G :grep '\b\b'<CR>
nmap <silent> <leader>l :set list!<CR>
nmap <silent> <leader>w :set wrap!<CR>
nmap <silent> <leader>S :set spell!<CR>
nmap <silent> <leader>f :let @" = bufname("%")<CR>
nmap <silent> <leader>F :let @" = expand("%:p")<CR>
nmap <silent> ZW :w<CR>

nmap <silent> [% :call searchpair('\[', '', '\]', 'Wb')<CR>
nmap <silent> ]% :call searchpair('\[', '', '\]', 'W')<CR>
nmap <silent> [< :call searchpair('<', '', '>', 'Wb')<CR>
nmap <silent> ]> :call searchpair('<', '', '>', 'W')<CR>

nnoremap ' `

function Joinoperator(submode)
	normal $mj
	'[,']join
	normal 'jl
endfunction
nnoremap J :silent set operatorfunc=Joinoperator<CR>g@
set nojoinspaces

execute pathogen#infect()

let g:ctrlp_switch_buffer = ''
let g:ctrlp_user_command = 'find %s -type f -maxdepth 8 ! -ipath "*/.git/*" ! -ipath "*/node_modules/*"'
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](\.git|node_modules)$',
	\ 'file': '\v\.(exe|so|dll)$'
	\ }