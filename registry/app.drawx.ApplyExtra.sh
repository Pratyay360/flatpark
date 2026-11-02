#!/bin/sh
set -eu

# DrawX is a Tauri v2 app (offline whiteboard, Excalidraw-based)
# It's a single binary at usr/bin/drawx

EXTRA_DIR="/app/extra"
DEB_FILE="drawx.deb"

# Check that the .deb exists
if [ ! -f "$DEB_FILE" ]; then
    echo "ERROR: $DEB_FILE not found"
    exit 1
fi

# Extract the data.tar.gz (the main payload) from the .deb
cd /tmp
ar -x "$DEB_FILE" data.tar.gz 2>/dev/null

# Check if extraction succeeded
if [ ! -f "data.tar.gz" ]; then
    echo "ERROR: Failed to extract data.tar.gz"
    exit 1
fi

# Extract usr/bin/drawx to /app/extra
cd /tmp
# Extract only the usr/bin/drawx file (not the whole tree)
tar -xzf data.tar.gz -C /tmp/usr/bin/drawx 2>/dev/null

# Verify the binary was extracted
if [ ! -f "/tmp/usr/bin/drawx" ]; then
    echo "ERROR: Failed to extract drawx binary"
    exit 1
fi

# Move to /app/extra
mkdir -p "$EXTRA_DIR"
mv "/tmp/usr/bin/drawx" "$EXTRA_DIR/drawx"

# Make it executable
chmod +x "$EXTRA_DIR/drawx"

echo "Successfully extracted drawx to $EXTRA_DIR/drawx"
