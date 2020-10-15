let s:Exists = function('glob')

function! s:TryGlobs(...)
	let n = a:0

	for i in range(n)
		let ext = a:000[i]

		let target = expand("%:r") . "." . ext

		if s:Exists(target) != "" || i is n - 1
			return target
		endif
	endfor

	throw "unreachable"
endfunction

function! s:CAltFile()
	let ext = expand("%:e")

	if ext ==? "c" || ext ==? "cpp" || ext ==? "cxx" || ext ==? "m" || ext ==? "mm"
		return s:TryGlobs("hxx", "h")
	else
		return s:TryGlobs("m", "mm", "cpp", "cxx", "cc", "c")
	endif
endfunction

function! s:SpecAlt()
	if expand("%:e:e:r") ==? "spec"
		return expand("%:r:r") . "." . expand("%:e")
	else
		return expand("%:r") . ".spec." . expand("%:e")
	endif
endfunction

function! s:Alt()
	if &ft ==# "c" || &ft ==# "cpp" || &ft ==# "objc" || &ft ==# "objcpp"
		return s:CAltFile()
	elseif &ft ==# "javascript" || &ft ==# "python" || &ft ==# "ruby"
		return s:SpecAlt()
	endif

	echohl Error
	echo "Can't handle filetype \"" . &ft . "\""
	echohl None
endfunction

function! s:AFileToggle(command, mods)
	let alt = s:Alt()

	if empty(alt)
		return
	endif

	execute a:mods . " " . a:command . " " . alt
endfunction

command! A  call s:AFileToggle("edit", <q-mods>)
command! AS call s:AFileToggle("split", <q-mods>)
command! AV call s:AFileToggle("vsplit", <q-mods>)
command! AT call s:AFileToggle("tabe", <q-mods>)

let s:test = 0
if s:test
	silent f yo.spec.js
	set ft=javascript
	call assert_equal(s:Alt(), "yo.js")

	silent f yo.js
	set ft=javascript
	call assert_equal(s:Alt(), "yo.spec.js")

	silent f lots.of.dots.js
	set ft=javascript
	call assert_equal(s:Alt(), "lots.of.dots.spec.js")

	silent f lots.of.dots.spec.js
	set ft=javascript
	call assert_equal(s:Alt(), "lots.of.dots.js")

	" -----------

	silent f hi.mm
	set ft=objcpp
	call assert_equal(s:Alt(), "hi.h")

	silent f hi.m
	set ft=objc
	call assert_equal(s:Alt(), "hi.h")

	silent f hi.c
	set ft=c
	call assert_equal(s:Alt(), "hi.h")

	silent f hi.cpp
	set ft=cpp
	call assert_equal(s:Alt(), "hi.h")

	silent f hi.cxx
	set ft=cpp
	call assert_equal(s:Alt(), "hi.h")

	silent f hi.cc
	set ft=cpp
	call assert_equal(s:Alt(), "hi.h")

	" -----------

	let s:Exists = { s -> s ==# "hi.mm" }
	set ft=c
	silent f hi.h
	call assert_equal(s:Alt(), "hi.mm")

	let s:Exists = { s -> s ==# "hi.m" }
	set ft=c
	silent f hi.h
	call assert_equal(s:Alt(), "hi.m")

	let s:Exists = { s -> s ==# "hi.c" }
	set ft=c
	silent f hi.h
	call assert_equal(s:Alt(), "hi.c")

	let s:Exists = { s -> s ==# "hi.cpp" }
	set ft=c
	silent f hi.h
	call assert_equal(s:Alt(), "hi.cpp")

	let s:Exists = { s -> s ==# "hi.cxx" }
	set ft=c
	silent f hi.h
	call assert_equal(s:Alt(), "hi.cxx")

	let s:Exists = { s -> s ==# "hi.ccc" }
	set ft=c
	silent f hi.h
	call assert_equal(s:Alt(), "hi.cc")

	let s:Exists = { -> 0 }
	set ft=c
	silent f hi.h
	call assert_equal(s:Alt(), "hi.c")

	let s:Exists = function('glob')

	echo "test run finished"
endif
