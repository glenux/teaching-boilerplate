#!/bin/sh

set -u
set -e

ARGS="$*"
echo "Arguments: $ARGS"

EXT_UID=${EXT_UID:-999}
EXT_GID=${EXT_GID:-999}

if ! grep "^[^:]*:[^:]*:$EXT_UID:" /etc/group ; then
	groupadd -g "$EXT_GID" appuser
fi

if ! grep "^[^:]*:[^:]*:$EXT_UID:" /etc/passwd ; then
	useradd -r -u "$EXT_UID" -g appuser appuser
fi

exec gosu appuser make "$@"
