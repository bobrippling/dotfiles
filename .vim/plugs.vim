let g:cartographer_enabled = 1
call plug#begin(split(&runtimepath, ",")[0] . "/bundle")

" Interface
"Plug 'junegunn/gv.vim', { 'on': 'GV' }
Plug 'junegunn/goyo.vim', g:cartographer_enabled ? {} : { 'on': 'Goyo', 'commit': 'fa0263d456dd43f5926484d1c4c7022dfcb21ba9' }
Plug 'preservim/vim-wordy', g:cartographer_enabled ? {} :  { 'on': [ 'NoWordy', 'NextWordy', 'PrevWordy', 'Wordy' ], 'commit': '590927f57277666e032702b26e4e0c82717cc3cb' }
"Plug 'junegunn/vim-peekaboo'

" VCS
Plug 'tpope/vim-fugitive', g:cartographer_enabled ? {} : { 'on': [ 'Gdiff', 'Ge', 'G', 'Gsplit', 'Gvsplit', 'GBrowse' ], 'commit': '1d18c696c4284e9ce9467a5c04d3adf8af43f994' }
Plug 'https://codeberg.org/bobrippling/jj.vim', { 'branch': 'main' }
Plug 'bobrippling/diffconflicts', { 'branch': 'master' } " whiteinge/diffconflicts, or jj-specific: rafikdraoui/jj-diffconflicts

if g:cartographer_enabled && has('nvim')
	Plug 'bobrippling/cartographer.vim', { 'branch': 'master' }
endif

" Boost native functionality
"Plug 'tpope/vim-abolish', { 'on': ['Abolish', 'Subvert'] }
"Plug 'stefandtw/quickfix-reflector.vim'
Plug 'bobrippling/vim-bg', { 'remote': 'github-me', 'branch': 'master' }
Plug 'bobrippling/vim-obsession', { 'remote': 'github-me', 'branch': 'master' } " tpope/vim-obsession " don't lazy load - need autocmds on :source <session>
"Plug 'bobrippling/SkyBison' " https://github.com/paradigm/SkyBison
Plug 'bobrippling/vim-vmath', { 'branch': 'master' } " https://github.com/nixon/vim-vmath
Plug 'bobrippling/vim-jump', { 'branch': 'master' }
Plug 'mbbill/undotree', { 'commit': '6fa6b57cda8459e1e4b2ca34df702f55242f4e4d' } " pure-vimscript undo
Plug 'bobrippling/nvim-osc52-tmux', { 'branch': 'main' }

" Motions, etc
Plug 'tpope/vim-surround', { 'commit': '3d188ed2113431cf8dac77be61b842acb64433d9' }
Plug 'cposture/vim-textobj-argument', { 'commit': 'f8f8758b3781f129149742730ba4c505ff534c38' } " for [(, ]) etc, success of b4winckler/vim-angry
Plug 'coderifous/textobj-word-column.vim', { 'commit': 'cb40e1459817a7fa23741ff6df05e4481bde5a33' }
Plug 'https://git.sr.ht/~foosoft/vim-argwrap', { 'tag': '24.1.15.0' }
"Plug 'folke/which-key.nvim'

Plug 'kana/vim-textobj-user', { 'commit': '41a675ddbeefd6a93664a4dc52f302fe3086a933' }
Plug 'kana/vim-textobj-entire', { 'commit': '64a856c9dff3425ed8a863b9ec0a21dbaee6fb3a' }
Plug 'kana/vim-textobj-line', { 'commit': '1a6780d29adcf7e464e8ddbcd0be0a9df1a37339' }
" too slow:
"Plug 'tyru/vim-textobj-underscore', { 'branch': 'support-3-cases' } " a_, i_
Plug 'bobrippling/vim-textobj-indent', { 'branch': 'master' } " ai, aI
"Plug 'kana/vim-textobj-lastpat' " i/, a?
Plug 'kana/vim-textobj-fold', { 'commit': '78bfa22163133b0ca6cda63b5b5015ed4409b2ee' }
Plug 'bobrippling/vim-textobj-lastchange', { 'branch': 'master' }
Plug 'preservim/vim-textobj-sentence', { 'commit': 'c5dd562aff2c389dfc8cd55e6499854d352a80b8' }

Plug 'vim-scripts/ReplaceWithRegister', { 'commit': '832efc23111d19591d495dc72286de2fb0b09345' } " script 2703
Plug 'arthurxavierx/vim-caser', { 'commit': '6bc9f41d170711c58e0157d882a5fe8c30f34bf6' }

" Windows, tabs etc
Plug 'kana/vim-submode', { 'commit': 'd29de4f55c40a7a03af1d8134453a703d6affbd2' }
Plug 'andymass/vim-tradewinds', { 'commit': '2266ab436d4777785f144f59bb5e854a312dcb24' }
if 0 && g:machine_fast
	Plug 'ctrlpvim/ctrlp.vim', { 'tag': '1.81' }
else
	Plug 'bobrippling/vim-pinpoint', { 'branch': 'master' }
endif
Plug 'bobrippling/vim-cmdline-match'
Plug 'bobrippling/a.vim', { 'branch': 'master' }
Plug 'bobrippling/unnest.nvim', { 'branch': 'main' } " yorickpeterse/brianhuster

" Filetype specific
Plug 'bobrippling/org.vim', g:cartographer_enabled ? {} : { 'for': 'org', 'branch': 'master' }

" Code
Plug 'tpope/vim-commentary', { 'commit': '64a654ef4a20db1727938338310209b6a63f60c9' }
Plug 'bobrippling/vim-pear', { 'branch': 'master' }
Plug 'bobrippling/vim-supersleuth', { 'branch': 'master' }
Plug 'godlygeek/tabular', g:cartographer_enabled ? {} : { 'on': [ 'Tabularize', 'AddTabularPattern', 'AddTabularPipeline' ], 'commit': '12437cd1b53488e24936ec4b091c9324cafee311' }
" ^ or junegunn/vim-easy-align

" LSP
if has('nvim')
	Plug 'neovim/nvim-lspconfig', { 'tag': 'v2.7.0' }
	" ^ can't lazy load - see notes in plugin/lsp/setup.lua
	" { 'on': [ 'LspStart', 'LspInfo', 'LspRestart' ] }

	" completion - use lsp's omnifunc (lsp/setup.vim)
	" see plugin/bundle--nvim-cmp.vim
	Plug 'hrsh7th/nvim-cmp', { 'commit': 'b5311ab3ed9c846b585c0c15b7559be131ec4be9' }
	Plug 'hrsh7th/cmp-nvim-lsp', { 'commit': 'a8912b88ce488f411177fc8aed358b04dc246d7b' } " show completions from lsp (+capabilities, lsp/setup.vim)
	Plug 'bobrippling/cmp-buffer', { 'branch': 'feat/show-source' } " complete words from bufnr, fork of hrsh7th/cmp-buffer
	"Plug 'hrsh7th/cmp-omni' " don't need - can invoke omni ourselves
	"Plug 'hrsh7th/cmp-cmdline' " doesn't play with wildcards
	"Plug 'hrsh7th/cmp-path' " C-X, C-F
endif
"Plug 'neoclide/coc.nvim'
"Plug 'dense-analysis/ale'

" Colours
Plug 'bobrippling/vim-illuminate', { 'branch': 'master' } " https://github.com/RRethy/vim-illuminate
Plug 'bobrippling/vim-papercolor', { 'branch': 'master' } " NLKNguyen/papercolor-theme
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
