function! rtp#exists(path)
	let paths = split(&rtp, ',')
	let paths = filter(paths, 'stridx(v:val, a:path) >= 0')
	let paths = filter(paths, 'isdirectory(v:val) || filereadable(v:val)')

	return !empty(paths)
endfunction
