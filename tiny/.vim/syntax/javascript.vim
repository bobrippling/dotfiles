augroup javascript
  autocmd!
  autocmd FileType javascript,typescript setlocal et ts=4 sw=4
  autocmd FileType javascript,typescript syntax keyword yieldKeyword yield
augroup END

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

highlight link yieldKeyword javaScriptOperator
