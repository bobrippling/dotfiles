command! -bar -register Vsdiff difft|let tmpft=&ft|vnew|se bt=nofile|let &ft=tmpft|unlet tmpft|pu<reg>|1d_|difft
