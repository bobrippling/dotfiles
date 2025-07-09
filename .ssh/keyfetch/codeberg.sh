#!/bin/sh

usage(){
	echo >&2 "Usage: $0 get"
	exit 2
}

if test $# -ne 1 || test "$1" != get
then usage
fi

set -e

curl -fsSL https://codeberg.org/Codeberg/org/raw/branch/main/Imprint.md \
	| awk '
	/SSH Fingerprints/ { p = 1 }
	($1 ~ "^codeberg\\.org" || $2 ~ "^codeberg\\.org") && p
	' >> ~/.ssh/known_hosts
