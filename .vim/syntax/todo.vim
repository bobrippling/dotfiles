syn match TodoBacklog /\[ \].*/
syn match TodoInProgress /\[\.\].*/
syn match TodoBlocked /\[-\].*/
syn match TodoDone /\[x\].*/

hi TodoBacklog ctermfg=green
hi TodoInProgress ctermfg=yellow
hi TodoBlocked ctermfg=red
hi TodoDone ctermfg=blue
