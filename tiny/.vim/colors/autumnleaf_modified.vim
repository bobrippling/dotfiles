" -------------------------------------
" for vimrc:

"colo ir_black
set background=light
colo autumnleaf_modified
hi link Terminal Normal
hi Search ctermbg=green ctermfg=white
hi Error ctermbg=red ctermfg=black cterm=none
hi clear ErrorMsg | hi link ErrorMsg Error

autocmd Syntax qf syn match Ignore /.*\(\.\(spec\|example\)\.\|__.*__\).*/

" -------------------------------------
" for colors/autumnleaf_modifier.vim:
" Vim color file
" Maintainer: Anders Korte
" Last Change: 17 Oct 2004

" AutumnLeaf color scheme 1.0
" Modified by bobrippling, found @ https://www.vim.org/scripts/script.php?script_id=4109

set background=light

hi clear

if exists("syntax_on")
    syntax reset
endif

let colors_name="AutumnLeaf-Modified"


" Colors for the User Interface.

hi Cursor	guibg=#aa7733   guifg=#ffeebb   gui=bold
"hi Cursor   guibg=#FF7311
hi Normal	guibg=#fffdfa	guifg=black	gui=none
"hi NonText	guibg=#eafaea   guifg=#000099   gui=bold
hi NonText  guifg=#aaaaaa  guibg=#f8f8f8  gui=none

hi Visual	guibg=#fff8cc   guifg=black	gui=none
" hi VisualNOS

hi Linenr	guibg=bg	guifg=#999999 gui=none

" Uncomment these if you use Diff...??
" hi DiffText	guibg=#cc0000	guifg=white gui=none
" hi DiffAdd	guibg=#0000cc	guifg=white gui=none
" hi DiffChange	guibg=#990099	guifg=white gui=none
" hi DiffDelete	guibg=#888888	guifg=#333333 gui=none

hi Directory	guibg=bg	guifg=#337700   gui=none

hi IncSearch	guibg=#c8e8ff	guifg=black	gui=none
hi Search	guibg=#c8e8ff	guifg=black	gui=none
hi SpecialKey	guibg=bg	guifg=fg    	gui=none
hi Titled	guibg=bg	guifg=fg	gui=none

hi ErrorMsg	    guibg=bg	guifg=#cc0000   gui=bold
hi ModeMsg	    guibg=bg	guifg=#003399   gui=none
hi link	MoreMsg	    ModeMsg
hi link Question    ModeMsg
hi WarningMsg	    guibg=bg	guifg=#cc0000   gui=bold

hi StatusLine	guibg=#f2f3bf guifg=#000000	gui=none
hi StatusLineNC	guibg=#ededed	guifg=#000000	gui=none
"hi StatusLineNC	guibg=#ebeac1	guifg=#ffffff	gui=none

"hi VertSplit	guibg=#aa8866	guifg=#ffe0bb	gui=none
hi VertSplit   guifg=#ededed  guibg=#ededed  gui=none


" hi Folded
" hi FoldColumn
" hi SignColumn


" Colors for Syntax Highlighting.

hi Comment guibg=#ddeedd guifg=#002200 gui=none

hi Constant	guibg=bg    guifg=#003399 gui=none
hi String	guibg=bg    guifg=#003399 gui=none
hi Character	guibg=bg    guifg=#003399 gui=italic
hi Number	guibg=bg    guifg=#003399 gui=none
hi Boolean	guibg=bg    guifg=#003399 gui=none
hi Float	guibg=bg    guifg=#003399 gui=none

hi Identifier	guibg=bg    guifg=#003399 gui=none
hi Function	guibg=bg    guifg=#0055aa gui=none
hi Statement	guibg=bg    guifg=#003399 gui=none

hi Conditional	guibg=bg    guifg=#aa7733 gui=bold
hi Repeat	guibg=bg    guifg=#aa5544 gui=bold
hi link	Label	Conditional
hi Operator	guibg=bg    guifg=#aa7733 gui=none
hi link Keyword	Statement
hi Exception	guibg=bg    guifg=#228877 gui=bold

hi PreProc	    guibg=bg	guifg=#aa7733 gui=none
hi Include	    guibg=bg	guifg=#558811 gui=bold
hi link Define	    Include
hi link Macro	    Include
hi link PreCondit   Include

hi Type			guibg=bg    guifg=#007700 gui=bold
hi link StorageClass	Type
hi link Structure	Type
hi Typedef		guibg=bg    guifg=#009900 gui=italic

hi Special	    guibg=bg	    guifg=fg	    gui=none
hi SpecialChar	    guibg=bg	    guifg=fg	    gui=bold
hi Tag		    guibg=bg	    guifg=#003399   gui=bold
hi link Delimiter   Special
hi SpecialComment   guibg=#dddddd   guifg=#aa0000   gui=none
hi link Debug	    Special

hi Underlined guibg=bg guifg=blue gui=underline

hi Title    guibg=bg	guifg=fg    	gui=bold
hi Ignore   guibg=bg	guifg=#999999	gui=none
hi Error    guibg=red	guifg=white	gui=none
hi Todo	    guibg=bg	guifg=#aa0000   gui=none



" The same in cterm colors.
hi Cursor	ctermbg=6   ctermfg=14
hi Normal	ctermbg=15  ctermfg=0
hi NonText	ctermbg=10  ctermfg=1
hi Visual	ctermbg=14  ctermfg=0
" hi VisualNOS
hi Linenr	ctermbg=bg  ctermfg=7
" hi DiffText	ctermbg=4   ctermfg=15
" hi DiffAdd	ctermbg=1   ctermfg=15
" hi DiffChange	ctermbg=5   ctermfg=15
" hi DiffDelete	ctermbg=7   ctermfg=8
hi Directory	ctermbg=bg  ctermfg=2
hi IncSearch	ctermbg=9   ctermfg=0
hi Search	ctermbg=9   ctermfg=0
hi SpecialKey	ctermbg=bg  ctermfg=fg
hi Titled	ctermbg=bg  ctermfg=fg
hi ErrorMsg	ctermbg=bg  ctermfg=12
hi ModeMsg	ctermbg=bg  ctermfg=9
hi WarningMsg	ctermbg=bg  ctermfg=12
hi StatusLine	ctermbg=14  ctermfg=0
hi StatusLineNC	ctermbg=6   ctermfg=14
hi VertSplit	ctermbg=6   ctermfg=14
" hi Folded
" hi FoldColumn
" hi SignColumn
hi Comment	ctermbg=10  ctermfg=2
hi Constant	ctermbg=bg  ctermfg=9
hi String	ctermbg=bg  ctermfg=9  cterm=italic
hi Character	ctermbg=bg  ctermfg=9  cterm=italic
hi Number	ctermbg=bg  ctermfg=9  cterm=bold
hi Boolean	ctermbg=bg  ctermfg=9  cterm=bold
hi Float	ctermbg=bg  ctermfg=9  cterm=bold
hi Function	ctermbg=bg  ctermfg=9  cterm=bold
hi Statement	ctermbg=bg  ctermfg=9  cterm=bold
hi Conditional	ctermbg=bg  ctermfg=6  cterm=bold
hi Repeat	ctermbg=bg  ctermfg=6  cterm=bold
hi Operator	ctermbg=bg  ctermfg=6  cterm=bold
hi Exception	ctermbg=bg  ctermfg=2  cterm=bold
hi PreProc	ctermbg=bg  ctermfg=6
hi Include	ctermbg=bg  ctermfg=2  cterm=bold
hi Type		ctermbg=bg  ctermfg=2  cterm=bold
hi Typedef	ctermbg=bg  ctermfg=2  cterm=italic
hi Special	ctermbg=bg  ctermfg=fg cterm=bold
hi Tag		ctermbg=bg  ctermfg=9  cterm=bold
hi SpecialComment ctermbg=7 ctermfg=4
hi Underlined	ctermbg=bg  ctermfg=9  cterm=underline
hi Title	ctermbg=bg  ctermfg=fg cterm=bold
hi Ignore	ctermbg=bg  ctermfg=7
hi Error	ctermbg=12  ctermfg=15
hi Todo		ctermbg=bg  ctermfg=15

hi Normal	ctermbg=none  ctermfg=none " - unset Normal - don't interfere with :terminal (but use above for <fg/bg>

" additions
hi QuickFixLine cterm=none ctermbg=green ctermfg=white
hi Ignore ctermfg=darkcyan
hi LineNr ctermfg=brown
hi clear Conditional | hi link Conditional Keyword
hi clear Repeat | hi link Repeat Keyword
hi DiffAdd ctermfg=white
hi Search ctermbg=cyan ctermfg=white
hi QuickFixLine ctermbg=4
"hi SpellBad ctermfg=white
hi SpellBad ctermfg=red ctermbg=none

hi link Terminal Normal
hi Search ctermbg=green ctermfg=white
hi Error ctermbg=red ctermfg=white cterm=none
hi clear ErrorMsg | hi link ErrorMsg Error

hi Identifier ctermfg=red
"hi Search ctermbg=yellow
hi DiffText ctermfg=white
hi PreProc ctermfg=blue cterm=none

hi StatusLine   ctermfg=black ctermbg=cyan cterm=none
hi StatusLineNC ctermfg=black ctermbg=cyan cterm=reverse

hi link StatusLineTerm StatusLine
hi StatusLineTermNC ctermbg=black ctermfg=green cterm=none

" these closely mirror the TabLine and TabLineSel groups
hi TabLineItalic term=underline cterm=underline ctermbg=grey ctermfg=green
hi TabLineSelItalic term=bold cterm=bold,italic ctermfg=green
