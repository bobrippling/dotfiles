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
set wrap
set linebreak showbreak=>
if exists("&breakindent")
	set breakindent
	set breakindentopt+=shift:1
endif
" add bullet pointed lists:
let &formatlistpat = '^\s*\(\d\+\|-\s\+\)[\]:.)}\t ]\s*'

" os/files
set clipboard=
set undofile
if has("nvim")
	set undodir=~/.vim/undo-nvim
else
	set undodir=~/.vim/undo
endif
set cpoptions+=i
set fileencodings+=utf-16le
set sessionoptions-=options " no localoptions - mapping will be reapplied by plugins
set wildignore=*.o,*.d
set nomodeline
set directory=.
" must remove old ones, vim takes the first flag it finds:
function! s:viminfo(type, val)
	let parts = split(&viminfo, ",")
	call filter(parts, { i, v -> v[:len(a:type) - 1] !=? a:type })
	call add(parts, a:type . a:val)
	let &viminfo = join(parts, ",")
endfunction
call s:viminfo("'", "150") " marks for last N files, +oldfiles
call s:viminfo("<", "100") " registers up to N lines
call s:viminfo("s", "100") " items with contents up to 100kib
set viminfo+=r~/mnt/

" display
" ('statusline' set in plugin/...)
set noequalalways
set novisualbell
set scrolloff=1
set sidescroll=15
set sidescrolloff=5
if has("nvim") && exists("&smoothscroll")
	set smoothscroll
endif
set splitbelow splitright
set wildmode=longest:full,full " 'full' is necessary for wildmenu, comma to not jump into the menu straight away
set wildmenu
set wildignorecase
try | set wildoptions=pum | catch /^E474:/ | endtry
set laststatus=2
set showcmd
set shortmess=aoOTIt
try
	set diffopt+=vertical
catch /E474/
endtry
set tabstop=2 shiftwidth=0 noexpandtab smarttab
set history=2000
set lazyredraw
set foldopen-=block
set foldignore-=#
try | set foldcolumn=auto:3 | catch /E521/ | endtry " introduced in nvim, #13571
set complete-=u " unloaded buffers are too slow, but we'll take a dictionary
set completeopt+=menuone,longest | set completeopt-=preview
"try | set completeopt+=popup | catch /E521/ | endtry " introduced in nvim-0.10
set cmdwinheight=20
set fillchars=fold:\ |
if exists('+cursorlineopt')
	set cursorlineopt=screenline,number
endif
set listchars=nbsp:¬,extends:»,precedes:«,trail:•
set showmatch cpoptions-=m
set report=1
set synmaxcol=160
set belloff=error,esc,showmatch

" display (gui)
" m: menu bar
" M: don't source menu.vim
" T: toolbar
" r: right hand scrollbar
" L: left hand scrollbar when split
set go-=m go-=T go-=r go-=L
try | set go+=M | catch /E519/ | endtry

" display (colours)
set termguicolors " see also: gui-colors

" mouse
" undo nvim's default:
set mouse=

" buffers
set nohidden " defaults to true for neovim

" editing
set nojoinspaces
set cinoptions+=j1,J1,l1,N-s,t0,k1,(1s,u0,k0,m1
" (1s,u0 - indent 1shiftwidth inside unclosed parens, per-paren. u0: disable cumulative indents/per-paren
" k0     - indents inside if()/while() conditions match normal function indenting
" m1     - closing paren on its own line matches opening paren indent
" 'cindent' is set just for C (etc) files
augroup VimrcIndent
	autocmd!
	autocmd FileType javascript,typescript setlocal cinoptions-=u0,k0,m1
	autocmd FileType c,cpp setl cinkeys+=0#
augroup END
set cinoptions-=#0
"               ^~ these will be undone by ftplugin/c.vim
set cinkeys-=0#
"set cinkeys+=!<Tab> - disables tab in insert mode which is a nuisance

set formatoptions+=clnoqrt
if v:version >= 704
	set formatoptions+=j
endif
" set delcombine - delete combining character separately from base character

" terminal
set notimeout ttimeout " timeout on keycodes only, wait forever for mappings

if has("nvim")
	set inccommand=nosplit
else
	try
		autocmd! vimHints
	catch /E216/
	endtry
endif

nnoremap <expr> <silent> <leader>j ":<C-U>" . v:count1 . "n<CR>"
nnoremap <expr> <silent> <leader>J ":<C-U>" . v:count1 . "w\\|n<CR>"
nnoremap <expr> <silent> <leader>t ":<C-U>" . v:count1 . "tabn<CR>"
nnoremap <silent> <leader>h :noh<CR>
nnoremap <silent> <leader>H :setl hls!<CR>
nnoremap <silent> <leader>l :setl list! list?<CR>
nnoremap <silent> <leader>i :setl nu!<CR>
nnoremap <silent> <leader>I :setl rnu!<CR>
nnoremap <silent> <leader>w :setl wrap!<CR>
nnoremap <silent> <leader>S :setl spell!<CR>
nnoremap <silent> <leader>M :setl modifiable!<CR>
nnoremap <silent> <leader>m :update\|make<CR>
nnoremap <silent> <leader>T :<C-U>ccl\|wincmd T\|cope\|wincmd t<CR>
nnoremap <expr> <leader>e ":<C-U>e %" .. repeat(":h", v:count1) .. "/"
nnoremap <expr> <leader>s ":<C-U>sp %" .. repeat(":h", v:count1) .. "/"
nnoremap <expr> <leader>v ":<C-U>vs %" .. repeat(":h", v:count1) .. "/"
"nnoremap <expr> <leader>t ":<C-U>tabe %" .. repeat(":h", v:count1) .. "/"
nnoremap gS :echo synIDattr(synID(getcurpos()[1], getcurpos()[2], 0), "name")<CR>

nnoremap <silent> ZW :w<CR>
nnoremap <silent> ZE :e<CR>
nnoremap <silent> <C-W>N :vnew<CR>
nnoremap <silent> <C-W>X <C-W>1x

noremap ' `
nnoremap <C-Y> 3<C-Y>
nnoremap <C-E> 3<C-E>
vnoremap <C-Y> 3<C-Y>
vnoremap <C-E> 3<C-E>

" modifications to existing commands:
nnoremap Y y$
vnoremap zD $zygv"_x
" ^ see vim#8448, vimgolf#9v0063d76854000000000249, vim/vim#13695
" make v_D behave like v_zy
nnoremap <silent> gt :<C-U>exec 'normal' (tabpagenr("$") - v:count1) . "gT"<CR>

" new commands
nnoremap <silent> <C-W>2T <C-W>T:tabm-1<CR>
map g<CR> gjg^
map <C-W>gD <C-W>sgD

" available <C-W> mappings: aeuy (g is taken by tradewinds plugin)
nnoremap <silent> <C-W>y :set winfixheight!<CR>
nnoremap <silent> <C-W>u :set winfixwidth!<CR>
function! s:wineq_other()
	let h = &winfixheight
	let w = &winfixwidth
	set winfixheight winfixwidth
	wincmd =
	let &winfixheight = h
	let &winfixwidth = w
endfunction
nnoremap <silent> <C-W>g= :call <SID>wineq_other()<CR>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>
cnoremap <expr> <C-R>l '\%' .. getcurpos()[1] .. 'l'
cnoremap <expr> <C-R>c '\%' .. getcurpos()[2] .. 'c'

inoremap <C-G>j <Esc>jA
inoremap <C-G>k <Esc>kA

tnoremap `<C-N> <C-\><C-N>

syntax on
filetype on
filetype indent plugin on

" execute pathogen#infect()

let g:machine_fast = 1

let g:man_hardwrap = 1
let g:tar_nomax = 1
let g:pinpoint_preview_delay = 150

let g:rust_fold = 1
let g:rustfmt_autosave = 0

let g:netrw_use_errorwindow = 0

execute "source" split(&runtimepath, ",")[0] . "/plugs.vim"

set background=light
colorscheme PaperColor

let g:sh_fold_enabled = 1+2+4

let g:org_use_italics = 0
let g:org_highlight_tex = 0

if !g:machine_fast
	set redrawtime=250
	set nofsync
else
	set synmaxcol&
endif
