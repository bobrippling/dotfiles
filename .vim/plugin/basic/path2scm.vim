function! Path2scm(count, switches) abort range
	let mode = "open"
	let ci = ""
	let resolve_ci = 0

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
		elseif sw ==# "-b" || sw ==# "--branch"
			let i += 1
			if i == len(a:switches)
				echoerr "Need branch/commit for -b/--branch"
				return
			endif
			let ci = a:switches[i]
			let resolve_ci = 0
		elseif sw ==# "-c" || sw ==# "--commit"
			let i += 1
			if i == len(a:switches)
				echoerr "Need branch/commit for -c/--commit"
				return
			endif
			let ci = a:switches[i]
			let resolve_ci = 1
		else
			echoerr "Invalid switch " sw
			return
		endif
		let i += 1
	endwhile

	if resolve_ci
		try
			let ci = fugitive#RevParse(ci)
		catch /failed to parse revision/
			let ci = fugitive#RevParse(FugitiveRemote().remote_name . "/" . ci)
		endtry
	endif

	" currently all remotes don't distinguish between having a commit or branch in the url,
	" so no need to pass through `resolve_ci`
	let [line1, line2] = a:count > 0 ? [a:firstline, a:lastline] : [0, 0]
	let url = s:url_for_curbuf(ci, line1, line2)

	if mode ==# "open"
		call system("xargs open", url)
	elseif mode ==# "show"
		echo url
	elseif mode ==# "reg"
		let charwise = "c"
		call setreg(reg, url, charwise)
	endif
endfunction

function! s:url_for_curbuf(ci, start, end)
	if !exists("*FugitiveRemoteUrl")
		" trigger plug.vim to load fugitive with a r/o git invocation
		silent G rev-parse HEAD
	endif

	let u = FugitiveRemoteUrl()
	if empty(u)
		throw "empty remote url"
	endif

	let [ci, fname] = s:file_ver()

	if !empty(a:ci)
		let ci = a:ci
	elseif empty(ci)
		let ci = FugitiveHead()
		if empty(ci)
			let ci = "main"
		endif
	endif

	" pass type=blob and let the upstream deal with rewriting to tree
	return Path2Scm_Url(u, fname, ci, a:start, a:end, "blob")
endfunction

function! Path2Scm_Url(u, fname, ci, start, end, type)
	let u = a:u
	let u = substitute(u, 'git@\([^:]\+\):', 'https://\1/', '')
	let u = substitute(u, '\.git$', '', '')

	if u =~? 'gitlab.com/'
		return s:suffix_gitlab(u, a:fname, a:ci, a:start, a:end, a:type)
	elseif u =~? 'github.com/'
		return s:suffix_github(u, a:fname, a:ci, a:start, a:end, a:type)
	endif

	throw "path2scm: unrecognised host \"" . u . "\" (\"" . a:u . "\")"
endfunction

function! s:suffix_gitlab(base, fname, ci, start, end, type)
	let url = a:base . "/-/" . a:type . "/" . a:ci . "/" . a:fname
	if a:start
		let url .= "#L" . a:start . (a:end == a:start ? "" : "-" . a:end)
	endif
	return url
endfunction

function! s:suffix_github(base, fname, ci, start, end, type)
	return a:base . "/" . a:type . "/" . a:ci . "/" . a:fname . (a:start ? "#L" . a:start . "-L" . a:end . "=" : "")
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

	if fname =~? '^fugitive://'
		let [ci_obj, gitdir] = FugitiveParse(fname)
		let [ci, fname] = split(ci_obj, ':')
	else
		let ci = ''
		let tree = FugitiveWorkTree()
		let fname = FugitiveReal(fname)

		let fname = fname[len(tree) + 1:]
		"                             ^ '/'
	endif

	return [ci, fname]
endfunction

command! -range -nargs=* -bar Path2scm :<line1>,<line2>call Path2scm(<count>, [<f-args>])
