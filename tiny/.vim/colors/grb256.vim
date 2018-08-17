"based on
runtime colors/ir_black.vim

let g:colors_name = "grb256"

hi pythonSpaceError ctermbg=red guibg=red

hi Comment ctermfg=gray

hi StatusLine cterm=underline ctermbg=NONE ctermfg=lightgrey
hi StatusLineNC cterm=underline ctermbg=NONE ctermfg=grey

hi VertSplit ctermbg=black ctermfg=lightgrey
hi LineNr ctermfg=darkgray
hi CursorLine     guifg=NONE        guibg=#121212     gui=NONE      ctermfg=NONE        ctermbg=234
hi Function         guifg=#FFD2A7     guibg=NONE        gui=NONE      ctermfg=yellow       ctermbg=NONE        cterm=NONE
"hi Visual           guifg=NONE        guibg=#262D51     gui=NONE      ctermfg=NONE        ctermbg=236    cterm=NONE
hi Visual gui=none guifg=khaki guibg=olivedrab cterm=reverse

hi Error            guifg=NONE        guibg=NONE        gui=undercurl ctermfg=16       ctermbg=red         cterm=NONE     guisp=#FF6C60 " undercurl color
hi ErrorMsg         guifg=white       guibg=#FF6C60     gui=BOLD      ctermfg=16       ctermbg=red         cterm=NONE
hi WarningMsg       guifg=white       guibg=#FF6C60     gui=BOLD      ctermfg=16       ctermbg=red         cterm=NONE
hi SpellBad       guifg=white       guibg=#FF6C60     gui=BOLD      ctermfg=16       ctermbg=160         cterm=NONE

" ir_black doesn't highlight operators for some reason
hi Operator        guifg=#6699CC     guibg=NONE        gui=NONE ctermfg=lightblue   ctermbg=NONE        cterm=NONE

hi DiffAdd cterm=none ctermfg=black ctermbg=lightgreen
hi DiffDelete cterm=none ctermfg=black ctermbg=lightred
hi DiffChange cterm=none ctermfg=black ctermbg=lightcyan
hi DiffText ctermfg=white ctermbg=cyan cterm=none

hi SpecialKey guifg=#4a4a59 ctermfg=black cterm=bold

hi Search    guibg=peru  guifg=wheat ctermbg=darkgreen ctermfg=black cterm=standout
hi IncSearch guifg=green guibg=black cterm=none ctermfg=black ctermbg=green

hi Pmenu ctermfg=white ctermbg=darkgrey
hi PmenuSel ctermfg=16 ctermbg=156

hi NonText guifg=#4a4a59 guibg=grey15 cterm=bold ctermfg=blue
