if !exists('g:ctrlb_handlers')
	let g:ctrlb_handlers = []
endif
if index(g:ctrlb_handlers, function('pinpoint#UpgradeEditCmdline')) is -1
	let g:ctrlb_handlers += [function('pinpoint#UpgradeEditCmdline')]
endif

