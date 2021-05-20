function! cwdprops#in_network_mount()
	let here = getcwd()
	let mounts = systemlist("mount")
	for mount in mounts
		let parts = split(mount, " ")
		let path = parts[2]

		if path ==# "/"
			continue
		endif

		if here[:len(path)-1] ==? path
			let type = parts[4]
			if type ==? "fuse.sshfs"
				return 1
			endif
		endif
	endfor

	return 0
endfunction
