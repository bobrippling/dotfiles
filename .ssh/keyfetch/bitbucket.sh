#!/bin/sh

usage(){
	echo >&2 "Usage: $0 get"
	exit 2
}

if test $# -ne 1 || test "$1" != get
then usage
fi

set -e

ssh-keygen -R bitbucket.org
curl -fsSL https://bitbucket.org/site/ssh >> ~/.ssh/known_hosts
