#!/bin/sh

# for case-sensitive filesystems, terminfo directories are stored as
# their hex representation, rather than the char itself, so
# r/ -> 72/

usage(){
	echo >&2 "Usage: $0 dirs..."
	exit 2
}

if test $# -eq 0
then usage
fi

set -e

for arg
do
	if test "$arg" = --help || echo "$arg" | grep -q '...*'
	then usage
	fi

	ln -s "$arg" "$(perl -e "printf '%x', ord('$arg')")"
done
