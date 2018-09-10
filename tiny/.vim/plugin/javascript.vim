function! GotoJsTag()
    let tag = expand("<cword>")
    let savesearch = @/
    execute "normal gg/^import[^']*\\<" . tag . "\\>$F'hgf"
    let @/ = savesearch
endfunction

augroup JavaScript
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <C-]> :<C-U>call GotoJsTag()<CR>
    autocmd FileType javascript nnoremap <buffer> <C-W><C-]> :sp<CR>:<C-U>call GotoJsTag()<CR>
    autocmd FileType javascript set suffixesadd+=.js,.jsx
augroup END
