source ~/.vim/after/ftplugin/javascript.vim

set suffixesadd+=.ts,.tsx
if exists('b:undo_ftplugin')
	let b:undo_ftplugin .= '|setlocal suffixesadd-=.ts,.tsx'
endif
