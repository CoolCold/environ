#!/bin/bash
set -euo pipefail

ASDF_MD5="7777a54be51cfb07b0046451b339ffec"
BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

echo "Downloading ASDF v0.18.0..."
curl -sL "https://github.com/asdf-vm/asdf/releases/download/v0.18.0/asdf-v0.18.0-linux-amd64.tar.gz" -o /tmp/asdf.tar.gz

# Verify and extract
echo "$ASDF_MD5  /tmp/asdf.tar.gz" | md5sum -c - || { echo "Checksum FAILED!" >&2; rm -f /tmp/asdf.tar.gz; exit 1; }

tar -xzf /tmp/asdf.tar.gz -C "$BIN_DIR" asdf && rm /tmp/asdf.tar.gz

"$BIN_DIR/asdf" version
