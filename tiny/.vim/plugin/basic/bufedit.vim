let s:preview_winid = 0
let s:saved_laststatus = &laststatus
let s:current_list = []
let s:current_ent = ""
let s:timer = -1
let s:showre = 0

if !exists('g:cmdline_preview_delay')
	let g:cmdline_preview_delay = 0
endif
if !exists('g:cmdline_preview_colour')
	let g:cmdline_preview_colour = 1
endif


function! s:GetRe(pat) abort
	let pat = a:pat

	"let pat = substitute(pat, '.', '*&', 'g')
	"let pat = glob2regpat("*" . pat . "*")

	"let pat = substitute(pat, '[.*]', '\\&', 'g')
	"let pat = substitute(pat, '[^\].', '&.\\{-}', 'g')

	" escape: . * [ ] \ &
	let parts = split(pat, '\ze[][.*\\]')
	let result = []
	for i in range(len(parts))
		let part = parts[i]
		if i > 0
			call add(result, '\' . part[0])
			let part = part[1:]
		endif

		call add(result, substitute(part, '.', '&.\\{-}', 'g'))
	endfor

	let re = join(result, '')
	if &ignorecase && (!&smartcase || !s:ismixedcase(re))
		let re = '\c' . re
	else
		let re = '\C' . re
	endif
	return re
endfunction

function! s:ismixedcase(str) abort
	return tolower(a:str) !=# a:str
endfunction

function! s:MatchingBufs(pat, list) abort
	let pat = s:GetRe(a:pat)

	let bufs = empty(a:list) ? getbufinfo({ 'buflisted': 1 }) : a:list

	call filter(bufs, function('s:MatchAndTag', [pat]))
	call sort(bufs, 's:Cmp')

	return bufs
endfunction

function! s:MatchAndTag(pat, i, ent) abort
	let name = a:ent.name
	if empty(name)
		return 0
	endif
	if a:ent.bufnr is winbufnr(s:preview_winid)
		return 0
	endif

	let name = fnamemodify(name, ":~:.")
	let a:ent.name = name

	" vim's re isn't the same as perl, and we won't get the shortest match on a
	" line, despite using /.\{-}/
	" e.g.
	" Desktop/abc/package
	"       ^~^~^~~~~^^^^ package
	" instead of
	"             ^^^^^^^ package
	"
	" so, look for shortest:
	let start = -1
	for i in range(strlen(name))
		let [str2, start2, end2] = matchstrpos(name, a:pat, i)
		if start2 is -1
			break
		endif
		let [str, start, end] = [str2, start2, end2]
	endfor

	if start is -1
		return 0
	endif

	let a:ent.matchstr = str
	let a:ent.matchstart = start
	let a:ent.matchend = end
	let a:ent.matchlen = end - start

	return 1
endfunction

function! s:Cmp(a, b) abort
	let a = a:a
	let b = a:b

	let diff = a.matchlen - b.matchlen
	if diff | return diff | endif

	let diff = len(a.matchstr) - len(b.matchstr)
	if diff | return diff | endif

	return len(a.name) - len(b.name)
endfunction

function! s:CompleteBufs(ArgLead, CmdLine, CursorPos) abort
	let bufs = s:MatchingBufs(a:ArgLead, [])

	call map(bufs, { i, ent -> ent.name })

	return bufs
endfunction

function! s:BufEdit(glob, editcmd, mods) abort
	let glob = a:glob

	let ents = s:MatchingBufs(glob, [])
	if len(ents) < 1
		echoerr "No matches for" glob
		return
	endif

	" just pick the first to match the preview
	let path = ents[0].bufnr

	execute a:mods a:editcmd path
endfunction

function! s:BufEditPreview() abort
	if getcmdtype() != ":" || !empty(getcmdwintype())
		return
	endif

	let arg = s:CmdlineMatchArg()
	if empty(arg)
		call s:BufEditPreviewClose()
	else
		call s:BufEditPreviewQueue(arg)
	endif
endfunction

function! s:CmdlineMatchArg() abort
	let cmd = getcmdline()
	" TODO: getcmdlinepos for better matching
	let arg = substitute(cmd, '\v\C%(^|.*\|)[: \t]*Buf%(%[edit]|%[vsplit]|%[split]|%[tabedit])\s+([^|]*)$', '\1', '')
	if arg ==# cmd
		return ''
	endif
	return arg
endfunction

function! s:BufEditPreviewQueue(arg) abort
	if g:cmdline_preview_delay is 0
		call s:BufEditPreviewShow(a:arg)
	else
		" queue up to display after editing
		if s:timer isnot -1
			call timer_stop(s:timer)
		endif
		let s:timer = timer_start(g:cmdline_preview_delay, function('s:BufEditPreviewShow'))
	endif
endfunction

function! s:BufEditPreviewShow(arg_or_timerid) abort
	let arg = a:arg_or_timerid
	if type(arg) is v:t_number
		" called from timer
		let s:timer = -1
		let arg = s:CmdlineMatchArg()
		if empty(arg)
			call s:BufEditPreviewClose()
			return
		endif
	endif

	if !win_id2win(s:preview_winid)
		call s:BufEditPreviewOpen()
	endif

	" Optimisation: since we're not regex, we can detect when the search pattern
	" has just been added to, and keep narrowing down an existing list, instead
	" of starting from getbufinfo() each time
	if len(arg) < len(s:current_ent) || arg[:len(s:current_ent) - 1] !=# s:current_ent
		let s:current_list = []
	endif
	let matches = s:MatchingBufs(arg, s:current_list)
	let s:current_ent = arg
	let s:current_list = matches

	let buf = winbufnr(s:preview_winid)
	call setbufline(buf, 1, "preview for '" . arg . "'" . (s:showre ? " /" . s:GetRe(arg) . "/" : ""))

	let saved_win_id = win_getid()
	" goto the preview window for matchaddpos()
	if !win_gotoid(s:preview_winid)
		return
	endif

	call clearmatches()
	for i in range(s:preview_height() - 1)
		let details = ""

		if i >= len(matches)
			let line = ""
			let m = 0
		else
			let m = matches[i]
			let line = m.name
			if !g:cmdline_preview_colour
				let details =
							\ repeat(" ", m.matchstart) .
							\ "^" .
							\ repeat("~", m.matchend - m.matchstart - 1)
			endif
		endif

		if g:cmdline_preview_colour
			let linenr = i + 2
			call setbufline(buf, linenr, line)
			if type(m) isnot v:t_number
				call matchaddpos('BufEditMatch', [
				\   [linenr, m.matchstart + 1, m.matchend - m.matchstart]
				\ ])
				" , v:null, -1, { 'window': s:preview_winid })
				" ^ this seems to expose a window redrawing bug in vim
			endif
		else
			call setbufline(buf, i * 2 + 2, line)
			call setbufline(buf, i * 2 + 2 + 1, details)
		endif

		let i += 1
	endfor

	call win_gotoid(saved_win_id)

	redraw
endfunction

function! s:BufEditPreviewOpen() abort
	" affect the 7new below - we don't want an empty NonText line
	let s:saved_laststatus = &laststatus
	set laststatus=0

	execute 'botright' s:preview_height() 'new'
	let s:preview_winid = win_getid()
	set winfixheight buftype=nofile bufhidden=wipe

	wincmd p
endfunction

function! s:preview_height() abort
	return &cmdwinheight
endfunction

function! s:BufEditPreviewClose() abort
	if s:timer isnot -1
		call timer_stop(s:timer)
		let s:timer = -1
	endif

	if !s:preview_winid
		return
	endif
	" could win_gotoid() + q or win_execute(..., "q")
	" but the user can't really switch tabs while this is going on
	let win = win_id2win(s:preview_winid)
	let s:preview_winid = 0
	if !win
		return
	endif

	execute win "q"
	let &laststatus = s:saved_laststatus
	redraw
endfunction

command! -bar -complete=customlist,s:CompleteBufs -nargs=1 Bufedit    call s:BufEdit(<q-args>, "buffer", <q-mods>)
command! -bar -complete=customlist,s:CompleteBufs -nargs=1 Bufsplit   call s:BufEdit(<q-args>, "sbuffer", <q-mods>)
command! -bar -complete=customlist,s:CompleteBufs -nargs=1 Bufvsplit  call s:BufEdit(<q-args>, "vert sbuffer", <q-mods>)
command! -bar -complete=customlist,s:CompleteBufs -nargs=1 Buftabedit call s:BufEdit(<q-args>, "tabedit | buffer", <q-mods>)

augroup BufEdit
	autocmd!

	autocmd CmdlineChanged * call s:BufEditPreview()
	autocmd CmdlineLeave * call s:BufEditPreviewClose()
augroup END

highlight BufEditMatch ctermfg=blue
