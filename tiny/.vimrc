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

" display
set noequalalways
set novisualbell
set scrolloff=1
set sidescroll=1
set splitbelow splitright
set wildmode=list:longest,full
set wildmenu
set wildignorecase
set statusline=\ \%f%m%r%h%w\ %y[%{&ff}][%n]%{exists('w:quickfix_title')?\ '\ '.w:quickfix_title\ :\ ''}%=\ %{&winfixwidth?'W':''}%{&winfixheight?'H':''}[%l/%L]
set laststatus=2
set showcmd
set shortmess=aoOTIt
set diffopt+=vertical
set tabstop=2 shiftwidth=2 noexpandtab
set history=400
set lazyredraw
set synmaxcol=120 " don't highlight long lines

" editing
set cindent
set cinoptions+=j1,J1,l1,N-s,t0
set formatoptions+=clnoqrt
if v:version >= 704
	set formatoptions+=j
endif

if has("nvim")
	set inccommand=split
endif

let g:netrw_banner = 0
let g:netrw_dirhistmax = 0

nmap <silent> <leader>n :cn<CR>
nmap <silent> <leader>N :w\|cn<CR>
nmap <silent> <leader>j :n<CR>
nmap <silent> <leader>J :w\|n<CR>
nmap <silent> <leader>h :noh<CR>
nmap <silent> <leader>H :set hls!<CR>
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
nmap gS :echo synIDattr(synID(getcurpos()[1], getcurpos()[2], 0), "name")<CR>

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
nnoremap <silent> gt :<C-U>exec 'normal ' . repeat("gT", tabpagenr("$") - v:count1)<CR>
nnoremap <silent> <C-W>2T <C-W>T:tabm-1<CR>
nmap g<CR> gjg^
nmap <C-W>gD <C-W>sgD

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

function! IsLoneCmd(cmd)
	if getcmdtype() != ':'
		return 0
	endif

	let modifiers = '((vert%[ical]|lefta%[bove]|abo%[veleft]|rightb%[elow]|bel%[owright]|to%[pleft]|bo%[tright])\s+)*'
	return getcmdline() =~ ('\v(^|\|)\s*' . modifiers . a:cmd)
endfunction
function! CmdAlias(lhs, rhs)
	exec "cnoreabbrev <expr> " . a:lhs . " IsLoneCmd('" . a:lhs . "') ? '" . a:rhs . "' : '" . a:lhs . "'"
endfunction
call CmdAlias('vsb', 'vert sb')
call CmdAlias('tabcp', 'tabc\|tabp')
call CmdAlias('tabb', 'tabnew\|b')
if has("nvim")
	call CmdAlias('ster', 'new\|ter')
	call CmdAlias('vter', 'vnew\|ter')
else
	call CmdAlias('ster', 'ter')
	call CmdAlias('vter', 'vert ter')
endif

function Joinoperator(submode)
	normal $mj
	'[,']join
	normal 'jl
endfunction
function JoinoperatorNoSpace(submode)
	normal $mj
	'[,']join!
	normal 'jl
endfunction
nnoremap J :silent set operatorfunc=Joinoperator<CR>g@
nnoremap gJ :silent set operatorfunc=JoinoperatorNoSpace<CR>g@
set nojoinspaces

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

if exepath("ag") != ""
	set grepprg=ag\ --depth\ 6\ --ignore\ \"_[^_]\*/\"\ --ignore\ \"\*.o\"\ --ignore\ \"\*.d\"\ --ignore\ node_modules\ --ignore\ \"\*.min.\*\"\ --ignore\ dist
endif

autocmd BufReadPost *
\ if line("'\"") > 1 && line("'\"") <= line("$")
\ | exe "normal! g`\""
\ | endif

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

let g:Blockwise_default_mapping = 0

let g:Illuminate_delay = 0
let g:Illuminate_ftblacklist = []
