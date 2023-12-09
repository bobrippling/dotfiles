command! -bar -range UrlDecode <line1>,<line2>s/%[a-f0-9]\{2\}/\=nr2char("0x" . submatch(0)[1:])/g
command! -bar -range UrlEncode <line1>,<line2>s/[^a-zA-Z0-9_.-]/\=printf('%%%x', char2nr(submatch(0)))/g
