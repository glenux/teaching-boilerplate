#!/bin/sh

set -u
set -e

ARGS="$*"
echo "Arguments: $ARGS"

EXT_UID=${EXT_UID:-999}
EXT_GID=${EXT_GID:-999}

# Create missing directories
mkdir -p _cache
mkdir -p _build
mkdir -p .marp
mkdir -p /home/appuser

# Create user with given ID if needed
if ! grep -q "^[^:]*:[^:]*:$EXT_UID:" /etc/group ; then
	groupadd -g "$EXT_GID" appuser
fi

# Create group with given ID if needed
if ! grep -q "^[^:]*:[^:]*:$EXT_UID:" /etc/passwd ; then
	useradd -r -u "$EXT_UID" -g appuser appuser
fi

chown -R "$EXT_UID:$EXT_GID" _cache
chown -R "$EXT_UID:$EXT_GID" _build
chown -R "$EXT_UID:$EXT_GID" .marp
chown -R "$EXT_UID:$EXT_GID" /home/appuser

# Patch mkdocs configuration 
if [ -f mkdocs-patch.yml ]; then
  yq \
  	  eval-all \
  	  '. as $item ireduce ({}; . * $item)' \
  	  mkdocs-source.yml \
  	  mkdocs-patch.yml \
  	  > mkdocs.yml
fi

if [ "$1" = "shell" ]; then
	exec bash
else
	exec gosu "$EXT_UID:$EXT_GID" make "$@"
fi
