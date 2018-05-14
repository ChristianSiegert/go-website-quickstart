#!/bin/bash
# Usage:
#	./release.sh HOST REMOTE_USER
# release.sh uploads the build file to the production server and replaces the
# running version with the newly uploaded one. It takes two arguments: the SSH
# host to which to transfer the build file, and the username of the remote user
# whose home directory is used as destination.
set -eu

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >> /dev/null && pwd)"
HOST="$1"
USER="$2"

# Get name of created build file
BUILD_FILE=$(ls $PROJECT_DIR/build/*-linux-amd64.tar.xz)

# Copy build file to remote server
scp "$BUILD_FILE" "$HOST":"/home/$USER/website/versions"

# On remote server, extract uploaded file, stop old version, start new version.
BASENAME=$(basename "$BUILD_FILE")
DIRNAME=${BASENAME%-linux-amd64.tar.xz}
ssh "$HOST" "bash -c \" \
	set -eu; \
	cd /home/"$USER"/website/versions; \
	tar -xf "$BASENAME"; \
	ln -fsT "$DIRNAME" latest; \
	chgrp -R "$USER" latest "$BASENAME" "$DIRNAME"; \
	cd ..; \
	./stop.sh; \
	./start.sh; \
\""
