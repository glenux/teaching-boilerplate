#!/bin/sh

set -u
set -e

ARGS="$*"
echo "Arguments: $ARGS"

EXT_UID=${EXT_UID:-999}
EXT_GID=${EXT_GID:-999}

groupadd -g "$EXT_GID" appuser
useradd -r -u "$EXT_UID" -g appuser appuser

exec gosu appuser make "$@"
