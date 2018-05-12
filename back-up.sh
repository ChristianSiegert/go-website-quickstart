#!/bin/bash
# back-up.sh saves a compressed archive of source directory in destination
# directory.
set -eu

SOURCE_DIR="$1"
DESTINATION_DIR="$2"

if [ ! -d "$SOURCE_DIR" ]; then
	echo "Source is not a directory: $SOURCE_DIR";
	exit 1;
elif [ ! -d "$DESTINATION_DIR" ]; then
	echo "Destination is not a directory: $DESTINATION_DIR";
	exit 1;
fi

PARENT_DIR=$(dirname "$SOURCE_DIR")
BASENAME=$(basename "$SOURCE_DIR")
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
