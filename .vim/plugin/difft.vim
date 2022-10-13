" can't use `diffsp %` - doesn't read from filesystem
command! -bar DiffT vnew|r++edit#|1d_|setl nomod bt=nofile|difft|wincmd p|difft
