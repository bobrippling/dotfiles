syntax match Comment /^>\S.*/ contains=@NoSpell
"highlight Comment ctermfg=green

syntax match Link /https\?:\S\+/ contains=@NoSpell
"highlight Link ctermfg=blue
