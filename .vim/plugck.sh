#!/bin/sh

set -e

if test $# -ne 0
then
	echo >&2 "Usage: $0"
	exit 2
fi

grep "^\s*Plug '" plugs.vim |
while read p slug rest
do
	slug=$(echo "$slug" | tr -d "',")
	path=${slug#*/}

	(
		cd ~/.vim/bundle/"$path"
		b=$(git rev-parse --abbrev-ref origin/HEAD)
		o=${b%*/}

		n=$(git rev-list --count "..$b")
		if test $n -gt 0
		then printf '%s is behind %s by %s (latest commit %s)\n' "$slug" "$b" "$n" "$(git rev-parse "$b")"
		fi
	)
done
