#!/bin/bash
set -euo pipefail

ASDF_VERSION="${ASDF_VERSION:-v0.18.0}"
ASDF_DIR="${ASDF_DIR:-$HOME/.asdf}"
BIN_DIR="$HOME/.local/bin"

echo "=== Installing ASDF dependencies ==="
sudo apt-get update -qq
sudo apt-get install -y -qq git curl

echo "=== Downloading ASDF $ASDF_VERSION ==="
mkdir -p "$BIN_DIR"

# Detect architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64) ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
esac

# Download checksum and archive
DOWNLOAD_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-linux-${ARCH}.tar.gz"
CHECKSUM_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf-${ASDF_VERSION}-linux-${ARCH}.tar.gz.md5"

ARCHIVE_FILE="/tmp/asdf.tar.gz"
CHECKSUM_FILE="/tmp/asdf.tar.gz.md5"

echo "Downloading archive..."
curl -sL "$DOWNLOAD_URL" -o "$ARCHIVE_FILE"

echo "Downloading checksum..."
curl -sL "$CHECKSUM_URL" -o "$CHECKSUM_FILE"

echo "Verifying checksum..."
EXPECTED_MD5=$(cat "$CHECKSUM_FILE")
ACTUAL_MD5=$(md5sum "$ARCHIVE_FILE" | awk '{print $1}')
if [ "$EXPECTED_MD5" != "$ACTUAL_MD5" ]; then
    echo "ERROR: Checksum verification failed!"
    echo "Expected: $EXPECTED_MD5"
    echo "Actual:   $ACTUAL_MD5"
    rm -f "$ARCHIVE_FILE" "$CHECKSUM_FILE"
    exit 1
fi
echo "Checksum verified: $ACTUAL_MD5"

echo "Extracting archive..."
tar -xzf "$ARCHIVE_FILE" -C "$BIN_DIR" asdf
rm -f "$ARCHIVE_FILE" "$CHECKSUM_FILE"

echo "=== Configuring ASDF ==="
# Add to PATH
if ! grep -q ".local/bin" ~/.bash_profile 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bash_profile
fi
if ! grep -q ".asdf/shims" ~/.bash_profile 2>/dev/null; then
    echo 'export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"' >> ~/.bash_profile
fi

# Add completions
if ! grep -q "asdf completion bash" ~/.bashrc 2>/dev/null; then
    echo '. <(asdf completion bash)' >> ~/.bashrc
fi

# Export for current session
export PATH="$BIN_DIR:${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

echo "=== Verifying installation ==="
type -a asdf
asdf version

echo "=== ASDF $ASDF_VERSION installed successfully! ==="
echo "Open a new shell or run: source ~/.bash_profile"
