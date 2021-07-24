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
" must remove old ones, vim takes the first flag it finds:
function! s:viminfo(type, val)
	let parts = split(&viminfo, ",")
	call filter(parts, { i, v -> v[:len(a:type) - 1] !=? a:type })
	call add(parts, a:type . a:val)
	let &viminfo = join(parts, ",")
endfunction
call s:viminfo("'", "150") " marks for last N files
call s:viminfo("<", "100") " registers up to N lines
call s:viminfo("s", "100") " items with contents up to 100kib
set viminfo+=r~/mnt/


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
try | set foldcolumn=auto | catch /E521/ | endtry " introduced in nvim, #13571
set completeopt+=menuone,noselect
set cmdwinheight=20

" display (gui)
" m: menu bar
" M: don't source menu.vim
" T: toolbar
" r: right hand scrollbar
" L: left hand scrollbar when split
set go-=m go+=M go-=T go-=r go-=L


" editing
set comments-=mb:* | set comments+=mbn:*
set comments-=fb:- | set comments+=n:-
set cindent
set cinoptions+=j1,J1,l1,N-s,t0
set cinoptions-=#0
"               ^~ these will be undone by ftplugin/c.vim
set cinkeys-=0#
"set cinkeys+=!<Tab> - disables tab in insert mode which is a nuisance

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
nnoremap <silent> <leader>* :match IncSearch /\<\>/<CR>
nnoremap <silent> <leader>l :set list!<CR>
nnoremap <silent> <leader>i :setl nu!<CR>
nnoremap <silent> <leader>w :set wrap!<CR>
nnoremap <silent> <leader>S :set spell!<CR>
nnoremap <silent> <leader>f :let @" = bufname("%")<CR>
nnoremap <silent> <leader>F :let @" = expand("%:p")<CR>
nnoremap <silent> <leader>M :set modifiable!<CR>
nnoremap <silent> <leader>m :update\|make<CR>
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
nnoremap Y y$
nnoremap <silent> gt :<C-U>exec 'normal ' . repeat("gT", tabpagenr("$") - v:count1)<CR>
nnoremap <silent> <C-W>2T <C-W>T:tabm-1<CR>
map g<CR> gjg^
map <C-W>gD <C-W>sgD

" available <C-W> mappings: aeuy (g is taken by tradewinds plugin)
nnoremap <silent> <C-W>y :set winfixheight!<CR>
nnoremap <silent> <C-W>u :set winfixwidth!<CR>

cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

vnoremap g/ <Esc>'</\%V

syntax on
filetype on
filetype indent plugin on

" execute pathogen#infect()

call plug#begin(split(&runtimepath, ",")[0] . '/bundle')

" Interface
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }

" Boost native functionality
Plug 'tpope/vim-abolish', { 'on': ['Abolish', 'Subvert'] }
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'bobrippling/vim-bg', { 'remote': 'github-me' }
Plug 'bobrippling/vim-obsession', { 'remote': 'github-me' } " tpope/vim-obsession " don't lazy load - need autocmds on :source <session>
"Plug 'bobrippling/SkyBison' " https://github.com/paradigm/SkyBison

" Motions, etc
Plug 'tpope/vim-surround'
Plug 'b4winckler/vim-angry'
Plug 'coderifous/textobj-word-column.vim'
Plug 'FooSoft/vim-argwrap'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user'

" Windows, tabs etc
Plug 'kana/vim-submode'
Plug 'andymass/vim-tradewinds'

" Filetype specific
Plug 'axvr/org.vim', { 'for': 'org' }

" Code
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'

" Colours
Plug 'bobrippling/vim-bogster', { 'remote': 'github-me' } " https://github.com/wojciechkepka/bogster
Plug 'bobrippling/vim-illuminate' " https://github.com/RRethy/vim-illuminate

" Testing
"Plug 'junegunn/vader.vim'

call plug#end()

colorscheme bogster
