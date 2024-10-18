syn match Comment /\/\/.*/
syn match Separator /^--\+/

"hi Comment
hi Separator ctermfg=green

" --------------

syn match TodoBacklog /\[ \].*/
syn match TodoInProgress /\[\.\].*/
syn match TodoBlocked /\[-\].*/
syn match TodoDone /\[x\].*/

hi TodoBacklog ctermfg=green guifg=#00aa00
hi TodoInProgress ctermfg=yellow guifg=#b58900
hi TodoBlocked ctermfg=red guifg=red
hi TodoDone ctermfg=blue guifg=#268bd2

setl foldmethod=indent
