syn match Comment /\/\/.*/
syn match Separator /^--\+/

"hi Comment
hi Separator ctermfg=green

" --------------

syn match TodoBacklog /\[ \].*/
syn match TodoInProgress /\[\.\].*/
syn match TodoBlocked /\[-\].*/
syn match TodoDone /\[x\].*/

hi TodoBacklog ctermfg=green guifg=green
hi TodoInProgress ctermfg=yellow guifg=yellow
hi TodoBlocked ctermfg=red guifg=red
hi TodoDone ctermfg=blue guifg=blue

setl foldmethod=indent
