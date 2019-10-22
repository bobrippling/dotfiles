if exepath("ag") != ""
	set grepprg=ag\ --depth\ 6\ --ignore\ \"_[^_]\*/\"\ --ignore\ \"\*.o\"\ --ignore\ \"\*.d\"\ --ignore\ node_modules\ --ignore\ \"\*.min.\*\"\ --ignore\ dist
endif
