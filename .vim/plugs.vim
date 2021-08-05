call plug#begin(split(&runtimepath, ",")[0] . "/bundle")

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
