call plug#begin(split(&runtimepath, ",")[0] . "/bundle")

" Interface
Plug 'tpope/vim-fugitive', { 'on': [ 'Gdiff', 'G', 'Gsplit', 'Gvsplit' ] }
Plug 'junegunn/gv.vim'
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

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-line'
" too slow:
"Plug 'tyru/vim-textobj-underscore', { 'branch': 'support-3-cases' } " a_, i_
"Plug 'kana/vim-textobj-indent' " ii, aI
"Plug 'kana/vim-textobj-lastpat' " i/, a?

Plug 'vim-scripts/ReplaceWithRegister' " script 2703

" Windows, tabs etc
Plug 'kana/vim-submode'
Plug 'andymass/vim-tradewinds'
Plug 'bobrippling/vim-pinpoint' "Plug 'ctrlpvim/ctrlp.vim'
exe "" | Plug 'bobrippling/vim-cmdline-match'

" Filetype specific
Plug 'axvr/org.vim', { 'for': 'org' }

" Code
Plug 'tpope/vim-commentary'
Plug 'bobrippling/vim-pear'
Plug 'bobrippling/vim-supersleuth'

" LSP
if has('nvim')
	Plug 'neovim/nvim-lspconfig', { 'on': [ 'LspStart', 'LspInfo', 'LspRestart' ] }
endif
"Plug 'neoclide/coc.nvim'
"Plug 'dense-analysis/ale'

" Colours
Plug 'bobrippling/vim-bogster', { 'remote': 'github-me' } " https://github.com/wojciechkepka/bogster
Plug 'bobrippling/vim-illuminate' " https://github.com/RRethy/vim-illuminate

" Testing
Plug 'junegunn/vader.vim', { 'for': 'vader', 'on': 'Vader' }

"Plug 'dstein64/vim-startuptime'

call plug#end()
