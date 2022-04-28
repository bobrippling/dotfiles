command! -range UrlDecode <line1>,<line2>s/%[a-f0-9]\{2\}/\=nr2char("0x" . submatch(0)[1:])/g
