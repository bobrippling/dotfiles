function! s:Pat(pat) abort
	"let pat = a:pat
	"let pat = substitute(pat, '.', '*&', 'g')
	"let pat = glob2regpat("*" . pat . "*")
	" or:
	"let pat = substitute(pat, '[.*]', '\\&', 'g')
	"let pat = substitute(pat, '.', '&.\\{-}', 'g')

	let result = []
	let parts = split(a:pat, '[.*]\zs', 1)
	let last = len(parts) - 1
	for i in range(len(parts))
		let part = parts[i]
		if i < last
			let sep = part[-1:]
			let part = part[:-2]
		endif
		call add(result, substitute(part, '.', '&.\\{-}', 'g'))
		if i < last
			call add(result, '\' . sep)
		endif
	endfor

	return tolower(join(result, ''))
endfunction

function! s:MatchingBufs(pat) abort
	let pat = s:Pat(a:pat)

	let bufs = getbufinfo({ 'buflisted': 1 })

	call filter(bufs, function('s:MatchAndTag', [pat]))
	call sort(bufs, 's:Cmp')

	return bufs
endfunction

function! s:MatchAndTag(pat, i, ent) abort
	let a:ent.name = fnamemodify(a:ent.name, ":~:.")
	let [str, start, end] = matchstrpos(tolower(a:ent.name), a:pat)

	if start == -1
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
	let bufs = s:MatchingBufs(a:ArgLead)

	call map(bufs, { i, ent -> ent.name })

	return bufs
endfunction

function! s:BufEdit(glob, editcmd, mods) abort
	let glob = a:glob

	let ents = s:CompleteBufs(glob, glob, 0)
	if len(ents) < 1
		echoerr "No matches for" glob
		return
	endif

	" just pick the first to match the preview
	let path = ents[0]

	execute a:mods a:editcmd path
endfunction

let s:preview_winid = 0
let s:saved_laststatus = &laststatus

if !exists('g:cmdline_preview_sync')
	let g:cmdline_preview_sync = 0
endif
if !exists('g:cmdline_preview_delay')
	let g:cmdline_preview_delay = 250
endif
let s:timer = -1

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
	" TODO: better version on eg
	let arg = substitute(cmd, '\v\C.*%(^|\|):*\s*Buf%(%[edit]|%[vsplit]|%[split]|%[tabedit])\s+([^|]*)$', '\1', '')
  if arg ==# cmd
		return ''
	endif
	return arg
endfunction

function! s:BufEditPreviewQueue(arg) abort
	if g:cmdline_preview_sync
		call s:BufEditPreviewShow(a:arg)
	else
		" queue up to display after editing
		if s:timer != -1
			call timer_stop(s:timer)
		endif
		let s:timer = timer_start(g:cmdline_preview_delay, function('s:BufEditPreviewShow'))
	endif
endfunction

function! s:BufEditPreviewShow(arg_or_timerid) abort
	let arg = a:arg_or_timerid
	if type(arg) ==# v:t_number
		" called from timer
		let s:timer = -1
		let arg = s:CmdlineMatchArg()
		if empty(arg)
			return
		endif
	endif

	if !win_id2win(s:preview_winid)
		call s:BufEditPreviewOpen()
	endif

	let matches = s:MatchingBufs(arg)

	let buf = winbufnr(s:preview_winid)
	call setbufline(buf, 1, "preview for '" . arg . "'")

	for i in range(3)
		if i >= len(matches)
			let line = ""
			let details = ""
		else
			let m = matches[i]
			let line = m.name
			let details =
						\ repeat(" ", m.matchstart) .
						\ "^" .
						\ repeat("~", m.matchend - m.matchstart - 1)
		endif

		call setbufline(buf, i * 2 + 2, line)
		call setbufline(buf, i * 2 + 2 + 1, details)

		let i += 1
	endfor
	redraw
endfunction

function! s:BufEditPreviewOpen() abort
	" affect the 7new below - we don't want an empty NonText line
	let s:saved_laststatus = &laststatus
	set laststatus=0

	botright 7new
	set winfixheight buftype=nofile bufhidden=wipe
	let s:preview_winid = win_getid()

	wincmd p
endfunction

function! s:BufEditPreviewClose() abort
	if s:timer != -1
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

command! -complete=customlist,s:CompleteBufs -nargs=1 Bufedit    call s:BufEdit(<q-args>, "edit", <q-mods>)
command! -complete=customlist,s:CompleteBufs -nargs=1 Bufsplit   call s:BufEdit(<q-args>, "split", <q-mods>)
command! -complete=customlist,s:CompleteBufs -nargs=1 Bufvsplit  call s:BufEdit(<q-args>, "vsplit", <q-mods>)
command! -complete=customlist,s:CompleteBufs -nargs=1 Buftabedit call s:BufEdit(<q-args>, "tabedit", <q-mods>)

augroup BufEdit
	autocmd!

	autocmd CmdlineChanged * call s:BufEditPreview()
	autocmd CmdlineLeave * call s:BufEditPreviewClose()
augroup END
