#!/bin/bash
# release.sh uploads the build file to the production server and replaces the
# running version with the newly uploaded one. The script is supposed to be
# located in the project’s root directory. It takes two arguments: the SSH host
# to which to transfer the build file, and the username of the remote user whose
# home directory is used as destination.
set -eu

HOST="$1"
USER="$2"

./build.sh linux-amd64;

# Get name of created build file
BUILD_FILE=$(ls ./build/*-linux-amd64.tar.xz)

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
