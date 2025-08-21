let g:cartographer_enabled = 1
call plug#begin(split(&runtimepath, ",")[0] . "/bundle")

" Interface
Plug 'tpope/vim-fugitive', g:cartographer_enabled ? {} : { 'on': [ 'Gdiff', 'Ge', 'G', 'Gsplit', 'Gvsplit', 'GBrowse' ], 'commit': '1d18c696c4284e9ce9467a5c04d3adf8af43f994' }
"Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'junegunn/goyo.vim', g:cartographer_enabled ? {} : { 'on': 'Goyo', 'commit': 'fa0263d456dd43f5926484d1c4c7022dfcb21ba9' }
Plug 'preservim/vim-wordy', g:cartographer_enabled ? {} :  { 'on': [ 'NoWordy', 'NextWordy', 'PrevWordy', 'Wordy' ], 'commit': '590927f57277666e032702b26e4e0c82717cc3cb' }
"Plug 'junegunn/vim-peekaboo'

if g:cartographer_enabled
	Plug 'bobrippling/cartographer.vim', { 'commit': '51a0d391cc10f3ee7997fc19972875dea28cf7dc' }
endif

" Boost native functionality
"Plug 'tpope/vim-abolish', { 'on': ['Abolish', 'Subvert'] }
"Plug 'stefandtw/quickfix-reflector.vim'
Plug 'bobrippling/vim-bg', { 'remote': 'github-me', 'commit': '609433c6684c98e9c5f5c2e1793a1cc91f3d8202' }
Plug 'bobrippling/vim-obsession', { 'remote': 'github-me', 'commit': '82c9ac5e130c92a46e043dd9cd9e5b48d15e286d' } " tpope/vim-obsession " don't lazy load - need autocmds on :source <session>
"Plug 'bobrippling/SkyBison' " https://github.com/paradigm/SkyBison
Plug 'bobrippling/vim-vmath', { 'commit': '72156b3d52195eb159e46d7b82102c2b38de7a20' } " https://github.com/nixon/vim-vmath
Plug 'bobrippling/vim-jump', { 'commit': '9933f4765f7f4d2d212e9435b0d1a776e53f8725' }
Plug 'mbbill/undotree', { 'commit': 'fe9a9d0645f0f5532360b5e5f5c550d7bb4f1869' } " pure-vimscript undo
Plug 'bobrippling/nvim-osc52-tmux', { 'commit': '95a8287de9bb10384f1db3f15504c64251a2d466' }

" Motions, etc
Plug 'tpope/vim-surround', { 'commit': '3d188ed2113431cf8dac77be61b842acb64433d9' }
Plug 'cposture/vim-textobj-argument', { 'commit': 'f8f8758b3781f129149742730ba4c505ff534c38' } " for [(, ]) etc, success of b4winckler/vim-angry
Plug 'coderifous/textobj-word-column.vim', { 'commit': 'cb40e1459817a7fa23741ff6df05e4481bde5a33' }
Plug 'FooSoft/vim-argwrap', { 'commit': 'f3e26a5ad249d09467804b92e760d08b1cc457a1' }
"Plug 'folke/which-key.nvim'

Plug 'kana/vim-textobj-user', { 'commit': '41a675ddbeefd6a93664a4dc52f302fe3086a933' }
Plug 'kana/vim-textobj-entire', { 'commit': '64a856c9dff3425ed8a863b9ec0a21dbaee6fb3a' }
Plug 'kana/vim-textobj-line', { 'commit': '1a6780d29adcf7e464e8ddbcd0be0a9df1a37339' }
" too slow:
"Plug 'tyru/vim-textobj-underscore', { 'branch': 'support-3-cases' } " a_, i_
Plug 'bobrippling/vim-textobj-indent', { 'commit': '46f8e2404796cd9f7ba0fd964ea6ccbaaf50d489' } " ai, aI
"Plug 'kana/vim-textobj-lastpat' " i/, a?
Plug 'kana/vim-textobj-fold', { 'commit': '78bfa22163133b0ca6cda63b5b5015ed4409b2ee' }
Plug 'bobrippling/vim-textobj-lastchange', { 'commit': '21d5bbab0301933bc36c954ef1e323c773afa665' }
Plug 'preservim/vim-textobj-sentence', { 'commit': 'c5dd562aff2c389dfc8cd55e6499854d352a80b8' }

Plug 'vim-scripts/ReplaceWithRegister', { 'commit': '832efc23111d19591d495dc72286de2fb0b09345' } " script 2703
Plug 'arthurxavierx/vim-caser', { 'commit': '6bc9f41d170711c58e0157d882a5fe8c30f34bf6' }

" Windows, tabs etc
Plug 'kana/vim-submode', { 'commit': 'd29de4f55c40a7a03af1d8134453a703d6affbd2' }
Plug 'andymass/vim-tradewinds', { 'commit': '2266ab436d4777785f144f59bb5e854a312dcb24' }
Plug 'bobrippling/vim-pinpoint', { 'commit': '94cebeb9d1d7c64a619aa3773ed766f11ee72436' } "Plug 'ctrlpvim/ctrlp.vim'
exe "" | Plug 'bobrippling/vim-cmdline-match'
Plug 'bobrippling/a.vim', { 'commit': '53de1565c30669e5148462c3ba8fac510c06261f' }
Plug 'bobrippling/unnest.nvim', { 'commit': '4e6eed08cb9792d82389ea50a6c27de378d018f8' } " yorickpeterse/brianhuster

" Filetype specific
Plug 'bobrippling/org.vim', g:cartographer_enabled ? {} : { 'for': 'org', 'commit': '1aa6361bfee2f211f17042c8aa6bf36060998ae2' }

" Code
Plug 'tpope/vim-commentary', { 'commit': 'c4b8f52cbb7142ec239494e5a2c4a512f92c4d07' }
Plug 'bobrippling/vim-pear', { 'commit': '0d11e43a536ef3b8181978e8bf931196f87ac2d2' }
Plug 'bobrippling/vim-supersleuth', { 'commit': '457000d21d6407c33d29b1cc15ec09b2c9e595e5' }
Plug 'godlygeek/tabular', g:cartographer_enabled ? {} : { 'on': [ 'Tabularize', 'AddTabularPattern', 'AddTabularPipeline' ], 'commit': '12437cd1b53488e24936ec4b091c9324cafee311' }
" ^ or junegunn/vim-easy-align

" LSP
if has('nvim')
	Plug 'neovim/nvim-lspconfig', { 'commit': '5bfcc89fd155b4ffc02d18ab3b7d19c2d4e246a7' }
	" ^ can't lazy load - see notes in plugin/lsp/setup.lua
	" { 'on': [ 'LspStart', 'LspInfo', 'LspRestart' ] }

	" completion - use lsp's omnifunc (lsp/setup.vim)
	" see plugin/bundle--nvim-cmp.vim
	Plug 'hrsh7th/nvim-cmp', { 'commit': 'b5311ab3ed9c846b585c0c15b7559be131ec4be9' }
	Plug 'hrsh7th/cmp-nvim-lsp', { 'commit': 'a8912b88ce488f411177fc8aed358b04dc246d7b' } " show completions from lsp (+capabilities, lsp/setup.vim)
	Plug 'bobrippling/cmp-buffer', { 'branch': 'feat/show-source', 'commit': '19b9366c36d6a39c9b381f06fd3b17ce7a776dd7' } " complete words from bufnr, fork of hrsh7th/cmp-buffer
	"Plug 'hrsh7th/cmp-omni' " don't need - can invoke omni ourselves
	"Plug 'hrsh7th/cmp-cmdline' " doesn't play with wildcards
	"Plug 'hrsh7th/cmp-path' " C-X, C-F
endif
"Plug 'neoclide/coc.nvim'
"Plug 'dense-analysis/ale'

" Colours
Plug 'bobrippling/vim-illuminate', { 'commit': '56e7df8f402a8302fa7f6cb21760d366a105d94c' } " https://github.com/RRethy/vim-illuminate
Plug 'bobrippling/vim-papercolor', { 'commit': 'df4a9a6039143ad5e6d8138c1cd1674b39581ed8' } " NLKNguyen/papercolor-theme
"Plug 'bobrippling/vim-bogster', { 'remote': 'github-me' } " https://github.com/wojciechkepka/bogster
"Plug 'bobrippling/vim-colors-solarized' " https://github.com/altercation/vim-colors-solarized
"Plug 'lifepillar/vim-solarized8' " solarized8_high
"Plug 'rakr/vim-one'

" Testing
Plug 'junegunn/vader.vim', g:cartographer_enabled ? {} : { 'for': 'vader', 'on': 'Vader', 'commit': '429b669e6158be3a9fc110799607c232e6ed8e29' }
"Plug 'dstein64/vim-startuptime'

" nice but not useful enough:
"Plug 'justinmk/vim-ipmotion' " {} motions handle whitespace
"Plug 'glacambre/firenvim' " vim in browser
"Plug willothy/flatten.nvim / yorickpeterse/unnest.nvim " nested nvims
"Plug 'mg979/vim-visual-multi' " multiple cursors
"Plug 'yorickpeterse/nvim-pqf', { 'do': luaeval('require("pqf").setup()') } " pretty-qf
"Plug 'tpope/vim-endwise' " vim-pear++
"Plug 'bfredl/nvim-incnormal'

call plug#end()
