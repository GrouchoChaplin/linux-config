#!/bin/bash

set -e

# 📁 New visible install directory
INSTALL_DIR="$HOME/Software/VSCode-CSS"
ALIAS_NAME="vscodecss"

# ✅ Download latest VS Code tar.gz
echo "📦 Downloading latest VS Code..."
wget -O /tmp/vscode.tar.gz "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"

# 🔧 Extract to install directory
echo "📂 Installing to $INSTALL_DIR ..."
mkdir -p "$INSTALL_DIR"
tar -xzf /tmp/vscode.tar.gz -C "$INSTALL_DIR" --strip-components=1

# ✅ Create alias in .bashrc or .zshrc
SHELL_RC="$HOME/.bashrc"
if [[ "$SHELL" == *zsh ]]; then
  SHELL_RC="$HOME/.zshrc"
fi

echo "🔗 Adding alias to $SHELL_RC ..."
if ! grep -q "$ALIAS_NAME" "$SHELL_RC"; then
  echo "alias $ALIAS_NAME='$INSTALL_DIR/code --enable-proposed-api be5invis.vscode-custom-css'" >> "$SHELL_RC"
  echo "✅ Alias '$ALIAS_NAME' added. Reload your terminal or run: source $SHELL_RC"
else
  echo "ℹ️ Alias '$ALIAS_NAME' already exists in $SHELL_RC"
fi

# ✅ Cleanup
rm /tmp/vscode.tar.gz
echo "🎉 Done! Run VS Code with: $ALIAS_NAME"
