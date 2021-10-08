let s:root = "."

function! fileprops#dirname(n) abort
	if a:n == 0
		return s:root
	endif

	return fnamemodify(getreg("%"), repeat(":h", a:n))
endfunction

