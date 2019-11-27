syn match javaScriptSpecial "\\\d\d\d\|\\."

syn region javaScriptInterpolation
            \ matchgroup=javaScriptInterpolationDelimiter
            \ start=/${/
            \ end=/}/
            \ contained

syn region javaScriptStringI
            \ start=+`+
            \ skip=+\\\\\|\\`+
            \ end=+`+
            \ contains=javaScriptInterpolation,javaScriptSpecial
            \ extend

hi link javaScriptStringI String
hi link javaScriptInterpolationDelimiter Delimiter

highlight JSTagLowLight ctermfg=black ctermbg=grey
