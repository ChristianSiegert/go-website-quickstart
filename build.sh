#!/bin/bash
# build.sh compiles the program for the specified build targets. A build target
# is a pair consisting of operating system and architecture, separated by a
# hyphen, e.g. “linux-amd64”. See [1] for a list of supported operating systems
# and architectures. If no build target is specified, the program is compiled
# for darwin-amd64 and linux-amd64.
# [1] https://github.com/golang/go/blob/master/src/go/build/syslist.go
set -eu

PROJECT_DIR="$GOPATH/src/github.com/ChristianSiegert/go-website-quickstart"
EXECUTABLE_FILENAME=$(basename "$PROJECT_DIR")

cd "$PROJECT_DIR"
BUILD_DIR="./build"

# Clean build directory
if [ -d "$BUILD_DIR" ]; then
	rm -r "$BUILD_DIR"
fi
mkdir -p "$BUILD_DIR"

# Read build targets from arguments
TARGETS="$@"

# Use default build targets if none were provided
if [ -z "$TARGETS" ]; then
	TARGETS="darwin-amd64 linux-amd64"
fi

# For each target, build binary, copy assets, and create compressed archive.
DATE=$(date "+%Y-%m-%d-%H.%M.%S")
for TARGET in $TARGETS; do
	ARCHIVE_FILE="$BUILD_DIR/$EXECUTABLE_FILENAME-$DATE-$TARGET.tar.xz"
	echo -n "Building for $TARGET ($ARCHIVE_FILE) ... "

	# Build
	OUTPUT_DIR="$BUILD_DIR/$TARGET"
	PAIR=(${TARGET//-/ })
	env GOARCH="${PAIR[1]}" GOOS="${PAIR[0]}" go build -o "$OUTPUT_DIR/$EXECUTABLE_FILENAME"

	# Copy assets
	cp -r "README.md" "templates" "$OUTPUT_DIR"
	mkdir "$OUTPUT_DIR/static"
	cp -r "static/css" "$OUTPUT_DIR/static"
	cp -r "static/js" "$OUTPUT_DIR/static"

	# Compress
	TEMP_OUTPUT_DIR="$BUILD_DIR/$EXECUTABLE_FILENAME-$DATE"
	mv "$OUTPUT_DIR" "$TEMP_OUTPUT_DIR"

	tar \
		-c \
		-C "$BUILD_DIR" \
		--exclude "*/.*" \
		-f "$ARCHIVE_FILE" \
		-J \
		--options xz:9 \
		$(basename "$TEMP_OUTPUT_DIR")

	mv "$TEMP_OUTPUT_DIR" "$OUTPUT_DIR"
	echo "Done"
done;
