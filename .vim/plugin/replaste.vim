command! -register Replaste silent %d_|exe 'pu' (empty(<q-reg>) ? '*' : <q-reg>)|1d_
