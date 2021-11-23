#!/bin/sh

ARGS="$*"
echo "Arguments: $ARGS"

exec make "$@"
