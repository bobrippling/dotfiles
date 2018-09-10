"based on
runtime colors/ir_black.vim

let colors_name = "grb256"

" tweak existing ---------
highlight Comment ctermfg=gray

highlight StatusLine ctermfg=grey ctermbg=NONE cterm=underline
highlight StatusLineNC ctermfg=lightgrey ctermbg=NONE cterm=underline

highlight VertSplit ctermfg=lightgrey ctermbg=black
highlight Function ctermfg=yellow
highlight Visual ctermfg=NONE ctermbg=darkgray cterm=reverse

highlight Error ctermfg=NONE cterm=NONE
highlight ErrorMsg ctermfg=NONE
highlight WarningMsg ctermfg=NONE ctermbg=red cterm=NONE

highlight Operator ctermfg=lightblue

highlight SpecialKey ctermfg=black cterm=bold

highlight Search ctermfg=black ctermbg=darkgreen cterm=standout

highlight NonText ctermfg=blue cterm=bold

highlight Pmenu ctermfg=black ctermbg=darkgreen
highlight PmenuSel ctermfg=darkgreen ctermbg=black

" new --------------------
highlight DiffAdd ctermfg=black ctermbg=lightgreen cterm=NONE
highlight DiffDelete ctermfg=black ctermbg=lightred cterm=NONE
highlight DiffChange ctermfg=black ctermbg=lightcyan cterm=NONE
highlight DiffText ctermfg=white ctermbg=cyan cterm=NONE

highlight Search ctermbg=yellow cterm=none ctermfg=red
highlight IncSearch ctermbg=yellow ctermfg=red cterm=reverse

highlight SpellBad ctermfg=white ctermbg=red cterm=none
