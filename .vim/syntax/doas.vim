hi DoAsAction ctermfg=blue
hi DoAsOption ctermfg=green
hi DoAsKeyword ctermfg=yellow
hi DoAsCommand ctermfg=black

syntax match DoAsAction /\v<%(permit|deny)>/
syntax match DoAsOption /\v<%(nopass|nolog|persist|keepenv|setenv)>/
syntax match DoAsKeyword /\v<as>/
syntax match DoAsCommand /\v<cmd>\s+.*/
syntax match Comment /#.*/
