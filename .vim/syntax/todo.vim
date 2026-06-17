syn match Comment /\/\/.*/
syn match Separator /^--\+/

"hi Comment
hi Separator ctermfg=green

" --------------

syn match TodoBacklog /\[ \].*/
syn match TodoInProgress /\[\.\].*/
syn match TodoBlocked /\[-\].*/
syn match TodoDone /\[[x+]\].*/
syn match TodoImportant /.*!!.*/

hi TodoBacklog ctermfg=green guifg=#00aa00
hi TodoInProgress ctermfg=yellow guifg=#b58900
hi TodoBlocked ctermfg=red guifg=red
hi TodoDone ctermfg=blue guifg=#268bd2
hi TodoImportant ctermfg=3 ctermbg=15 guifg=#ffff5f guibg=#444444

"setl foldmethod=indent
setl foldexpr=MarkdownFold()
