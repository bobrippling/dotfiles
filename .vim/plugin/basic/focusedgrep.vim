nnoremap <silent> <expr> <leader>g ":<C-U>Bggrep '\\b\\b' " . fileprops#dirname(v:count) . "<CR>"
nnoremap <silent> <expr> <leader>G ":<C-U>Bggrep '' " . fileprops#dirname(v:count) . "<CR>"
