#!/bin/sh

usage(){
	echo >&2 "Usage: $0 get"
	exit 2
}

if test $# -ne 1 || test "$1" != get
then usage
fi

set -e

if ! type jq >/dev/null 2>&1
then
	echo >&2 "$0: need jq"
	exit 1
fi

ssh-keygen -R github.com
curl -L https://api.github.com/meta |
	jq -r '.ssh_keys | .[]' |
	sed -e 's/^/github.com /' >>~/.ssh/known_hosts
