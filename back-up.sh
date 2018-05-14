#!/bin/bash
# Usage:
#	./back-up.sh DESTINATION_DIR
# back-up.sh creates a compressed tar file of the project directory and saves it
# in the destination directory.
set -eu

DESTINATION_DIR="$1"

if [ ! -d "$DESTINATION_DIR" ]; then
	echo "Destination is not a directory: $DESTINATION_DIR"
	exit 1
fi

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >> /dev/null && pwd)"
PARENT_DIR=$(dirname "$PROJECT_DIR")
BASENAME=$(basename "$PROJECT_DIR")
DATE=$(date "+%Y-%m-%d %H.%M.%S")
OUTPUT_FILE="$DESTINATION_DIR/$BASENAME $DATE.tar.xz"

echo -n "Saving backup (\"$OUTPUT_FILE\") ... "

tar \
	-c \
	-C "$PARENT_DIR" \
	--exclude "*/.DS_Store" \
	--exclude "$BASENAME/build" \
	--exclude "$BASENAME/debug" \
	-f "$OUTPUT_FILE" \
	-J \
	--options xz:9 \
	"$BASENAME"

echo "Done"
