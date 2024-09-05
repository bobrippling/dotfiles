call plug#begin(split(&runtimepath, ",")[0] . "/bundle")

" Interface
Plug 'tpope/vim-fugitive', { 'on': [ 'Gdiff', 'Ge', 'G', 'Gsplit', 'Gvsplit', 'GBrowse' ] }
"Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'preservim/vim-wordy', { 'on': [ 'NoWordy', 'NextWordy', 'PrevWordy', 'Wordy' ] }

" Boost native functionality
"Plug 'tpope/vim-abolish', { 'on': ['Abolish', 'Subvert'] }
"Plug 'stefandtw/quickfix-reflector.vim'
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
Plug 'bobrippling/vim-textobj-indent' " ai, aI
"Plug 'kana/vim-textobj-lastpat' " i/, a?
Plug 'kana/vim-textobj-fold'
Plug 'bobrippling/vim-textobj-lastchange'
Plug 'preservim/vim-textobj-sentence'

Plug 'vim-scripts/ReplaceWithRegister' " script 2703
Plug 'arthurxavierx/vim-caser'

" Windows, tabs etc
Plug 'kana/vim-submode'
Plug 'andymass/vim-tradewinds'
Plug 'bobrippling/vim-pinpoint' "Plug 'ctrlpvim/ctrlp.vim'
exe "" | Plug 'bobrippling/vim-cmdline-match'
Plug 'bobrippling/a.vim'

" Filetype specific
Plug 'bobrippling/org.vim', { 'for': 'org' }

" Code
Plug 'tpope/vim-commentary'
Plug 'bobrippling/vim-pear'
Plug 'bobrippling/vim-supersleuth'

" LSP
if has('nvim')
	" can't lazy load - see notes in plugin/lsp/rust.vim
	Plug 'neovim/nvim-lspconfig' ", { 'on': [ 'LspStart', 'LspInfo', 'LspRestart' ] }

	" completion - use lsp's omnifunc (lsp/setup.vim)
	" see plugin/bundle--nvim-cmp.vim
	Plug 'bobrippling/nvim-cmp', { 'branch': 'fix/cmdwin' } " fork of hrsh7th/nvim-cmp
	Plug 'hrsh7th/cmp-nvim-lsp' " show completions from lsp (+capabilities, lsp/setup.vim)
	Plug 'bobrippling/cmp-buffer', { 'branch': 'feat/show-source' } " complete words from bufnr, fork of hrsh7th/cmp-buffer
	"Plug 'hrsh7th/cmp-omni' " don't need - can invoke omni ourselves
	"Plug 'hrsh7th/cmp-cmdline' " doesn't play with wildcards
	"Plug 'hrsh7th/cmp-path' " C-X, C-F
endif
"Plug 'neoclide/coc.nvim'
"Plug 'dense-analysis/ale'

" Colours
Plug 'bobrippling/vim-illuminate' " https://github.com/RRethy/vim-illuminate
Plug 'bobrippling/vim-papercolor' " NLKNguyen/papercolor-theme
"Plug 'bobrippling/vim-bogster', { 'remote': 'github-me' } " https://github.com/wojciechkepka/bogster
"Plug 'bobrippling/vim-colors-solarized' " https://github.com/altercation/vim-colors-solarized
"Plug 'lifepillar/vim-solarized8' " solarized8_high
"Plug 'rakr/vim-one'

" Testing
Plug 'junegunn/vader.vim', { 'for': 'vader', 'on': 'Vader' }

"Plug 'dstein64/vim-startuptime'

call plug#end()
