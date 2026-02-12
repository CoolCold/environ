# ASDF Install Scripts

Fast, secure ASDF (v0.18.0) installation for Linux amd64.

## Files

- **`install-asdf.sh`** - Full-featured: auto-detects arch, adds shell completions, configures PATH
- **`install-asdf-simple.sh`** - Minimal: downloads, verifies MD5, installs to `~/.local/bin`
- **`install-asdf-oneliner.sh`** - Copy-paste ready one-liner for terminal

## Usage

### One-liner (quickest)
```bash
ASDF_MD5="7777a54be51cfb07b0046451b339ffec"; BIN_DIR="$HOME/.local/bin"; mkdir -p "$BIN_DIR"; curl -sL "https://github.com/asdf-vm/asdf/releases/download/v0.18.0/asdf-v0.18.0-linux-amd64.tar.gz" -o /tmp/asdf.tar.gz && echo "$ASDF_MD5  /tmp/asdf.tar.gz" | md5sum -c - && tar -xzf /tmp/asdf.tar.gz -C "$BIN_DIR" asdf && rm /tmp/asdf.tar.gz && "$BIN_DIR/asdf" version
```

### Simple script
```bash
bash install-asdf-simple.sh
```

### Full script
```bash
bash install-asdf.sh
# Then: source ~/.bash_profile
```

## Testing with LXD

```bash
lxc launch ubuntu:noble test-asdf
lxc file push install-asdf.sh test-asdf/tmp/
lxc exec test-asdf -- bash /tmp/install-asdf.sh
lxc stop test-asdf && lxc delete test-asdf
```

## Requirements

- Linux amd64
- `curl`, `md5sum`, `tar`
- Write access to `~/.local/bin/`

## Security

All scripts verify MD5 checksum (`7777a54be51cfb07b0046451b339ffec`) before installation.
