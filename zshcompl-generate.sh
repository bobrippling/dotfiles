#!/bin/sh

if test $# -ne 0
then
	echo >&2 "Usage: $0"
	exit 2
fi

for cmd in cargo rustup
do rustup completions zsh "$cmd" >~/.config/dotfiles/zshcompl/_"$cmd"
done

#ln -s <password-store>/src/completion/pass.zsh-completion ~/.config/dotfiles/zshcompl/_pass

#mkdir contrib
#cd contrib && git clone https://github.com/rupa/z
