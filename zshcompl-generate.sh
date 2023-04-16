#!/bin/sh

set -e

usage(){
	echo >&2 "Usage: $0 --all"
	echo >&2 "       $0 [rust] [pass=src] [z] [fd]"
	exit 2
}

here=~/.config/dotfiles

maybe_new(){
	if ! test -e "$2"
	then echo "new: $1"
	fi
}

gen_rust(){
	for cmd in cargo rustup
	do
		dest="$here"/zshcompl/_"$cmd"
		maybe_new "$cmd" "$dest"
		rustup completions zsh "$cmd" >"$dest"
	done
}

gen_pass(){
	dest="$here"/zshcompl/_pass
	maybe_new pass "$dest"
	ln -fs "$1"/src/completion/pass.zsh-completion "$dest"
}

gen_z(){
	mkdir -p contrib
	(
		cd contrib
		if test -e z
		then
			cd z
			git fetch -p --quiet
			git merge --ff-only --quiet
		else
			maybe_new z z
			git clone --quiet https://github.com/rupa/z
		fi
	)
}

gen_fd(){
	dest="$here"/zshcompl/_fd
	maybe_new fd "$dest"
	curl https://raw.githubusercontent.com/sharkdp/fd/master/contrib/completion/_fd \
		-fsSL \
		-o "$dest"
}

if test $# -eq 0
then usage
fi

for arg
do
	case "$arg" in
		--all)
			gen_rust
			gen_z
			gen_fd
			if ! test -e "$here"/zshcompl/_pass
			then echo >&2 "can't generate pass: no src"
			fi
			;;
		rust) gen_rust ;;
		pass=*)
			gen_pass "${arg#*=}"
			;;
		z) gen_z ;;
		fd) gen_fd ;;
		*) usage ;;
	esac
done
