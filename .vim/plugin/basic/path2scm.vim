function! Path2scm(switches) abort
	let mode = "open"

	let i = 0
	while i < len(a:switches)
		let sw = a:switches[i]
		if sw ==# "-s" || sw ==# "--show"
			let mode = "show"
		elseif sw ==# "-r" || sw ==# "--reg"
			let i += 1
			if i == len(a:switches)
				echoerr "Need register for -r/--reg"
				return
			endif
			let mode = "reg"
			let reg = a:switches[i]
		else
			echoerr "Invalid switch " sw
			return
		endif
		let i += 1
	endwhile

	let url = s:url(line("'<"), line("'>"))

	if mode ==# "open"
		call system("xargs open", url)
	elseif mode ==# "show"
		echo url
	elseif mode ==# "reg"
		let charwise = "c"
		call setreg(reg, url, charwise)
	endif
endfunction

function! s:url(begin, end)
	let u = FugitiveRemoteUrl()
	let u = substitute(u, 'git@\([^:]\+\):', 'https://\1/', '')

	if u =~? 'gitlab.com/'
		return s:suffix_gitlab(u, a:begin, a:end)
	elseif u =~? 'github.com/'
		return s:suffix_github(u, a:begin, a:end)
	endif

	throw "unrecognised remote (" . u . ")"
endfunction

function! s:suffix_gitlab(base, start, end)
	let [ci, fname] = s:file_ver()

	if empty(ci)
		let ci = FugitiveHead()
		if empty(ci)
			let ci = "main"
		endif
	endif

	return a:base . "/-/blob/" . ci . "/" . fname . "#L" . a:start
endfunction

function! s:suffix_github(base, start, end)
	let [ci, fname] = s:file_ver()

	if empty(ci)
		let ci = FugitiveHead()
		if empty(ci)
			let ci = "master"
		endif
	endif

	return a:base . "/blob/" . ci . "/" . fname . "#L" . a:start . "-L" . a:end . "="
endfunction

function! s:suffix_tfs()
	throw "todo"
	" http://tfs:8080/tfs/DefaultCollection/_git/Project?path=$converted_path&version=$version&_a=contents&line=$start_line&lineStyle=plain&lineEnd=$end_line&lineStartColumn=$start_col&lineEndColumn=$end_col
endfunction

function! s:file_ver() abort
	let fname = expand("%")
	if empty(fname)
		throw "No filename"
	endif

	let version_arg = ""
	if fname =~? '^fugitive://'
		let components = split(fname, "/", 1)
		let git_index = index(components, ".git")

		let ci = components[git_index + 2]
		let fname = join(components[git_index + 3:], "/")
	else
		let ci = ''
	endif

	return [ci, FugitivePath(fname, '')]
endfunction

command! -range -nargs=* -bar Path2scm call Path2scm([<f-args>])
