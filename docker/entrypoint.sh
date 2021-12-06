#!/bin/sh

set -u
set -e

ARGS="$*"
echo "Arguments: $ARGS"

EXT_UID=${EXT_UID:-999}
EXT_GID=${EXT_GID:-999}

# Create user with given ID if needed
if ! grep -q "^[^:]*:[^:]*:$EXT_UID:" /etc/group ; then
	groupadd -g "$EXT_GID" appuser
fi

# Create group with given ID if needed
if ! grep -q "^[^:]*:[^:]*:$EXT_UID:" /etc/passwd ; then
	useradd -r -u "$EXT_UID" -g appuser appuser
fi

if [ -d "_build" ]; then
	chown -R "$EXT_UID:$EXT_GID" _build
	chown -R "$EXT_UID:$EXT_GID" .marp
fi

if [ "$1" = "shell" ]; then
	exec bash
else
	exec gosu "$EXT_UID:$EXT_GID" make "$@"
fi
