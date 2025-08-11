#!/usr/bin/env bash

set -e

VERSION="${args[version]}"

INSTALL_DIR="${INSTALL_DIR:-/usr/local/manual}"
if [[ -n "${args[--dir]}" ]]; then
  INSTALL_DIR="${args[--dir]}"
fi

LINK_PATH="${LINK_DIR/nvim:-/usr/local/bin/nvim}"
if [[ -n "${args[--link]}" ]]; then
  LINK_PATH="${args[--link]}"
fi

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "❌ This installer only supports Linux."
  exit 1
fi

case "$(uname -m)" in
  x86_64|amd64) ARCH="x86_64" ;;
  arm64|aarch64) ARCH="arm64" ;;
  *) echo "❌ Unsupported architecture: $(uname -m)"; exit 1 ;;
esac

if [[ "$ARCH" == "x86_64" ]]; then
  ASSET="nvim-linux64.tar.gz"
elif [[ "$ARCH" == "arm64" ]]; then
  ASSET="nvim-linux-arm64.tar.gz"
fi

if [[ -z "$VERSION" || "$VERSION" == "latest" ]]; then
  echo "🔍 Fetching latest Neovim version..."
  VERSION=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest \
    | grep '"tag_name":' \
    | sed -E 's/.*"v([^"]+)".*/\1/')
fi

echo "📦 Installing Neovim v${VERSION} for Linux-${ARCH}..."
echo "📂 Target directory: $INSTALL_DIR"
echo "🔗 Symlink path: $LINK_PATH"

TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

DOWNLOAD_URL="https://github.com/neovim/neovim/releases/download/v${VERSION}/${ASSET}"

echo "⬇️ Downloading from: $DOWNLOAD_URL"
curl -LO "$DOWNLOAD_URL"

echo "📂 Extracting..."
tar xzf "$ASSET"

sudo mkdir -p "$INSTALL_DIR"
sudo rm -rf "$INSTALL_DIR/nvim"

sudo mv nvim-linux* "$INSTALL_DIR/nvim"

sudo mkdir -p "$(dirname "$LINK_PATH")"
sudo ln -sf "$INSTALL_DIR/nvim/bin/nvim" "$LINK_PATH"

echo "🧹 Cleaning up..."
cd ~
rm -rf "$TMP_DIR"

echo "✅ Neovim v${VERSION} installed successfully!"

