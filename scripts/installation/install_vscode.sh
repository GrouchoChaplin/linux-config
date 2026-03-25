#!/bin/bash

set -e

# 📁 Paths
INSTALL_DIR="$HOME/Software/VSCode-CSS"
CSS_DIR="$HOME/.vscode-style"
CSS_FILE="$CSS_DIR/custom.css"
ALIAS_NAME="vscodecss"

# ✅ Download latest VS Code tar.gz
echo "📦 Downloading latest VS Code..."
wget -O /tmp/vscode.tar.gz "https://code.visualstudio.com/sha/download?build=stable&os=linux-x64"

# 🔧 Extract to install directory
echo "📂 Installing VS Code to $INSTALL_DIR ..."
mkdir -p "$INSTALL_DIR"
tar -xzf /tmp/vscode.tar.gz -C "$INSTALL_DIR" --strip-components=1

# 🧬 Create custom CSS
echo "🎨 Creating custom CSS at $CSS_FILE ..."
mkdir -p "$CSS_DIR"
cat > "$CSS_FILE" <<EOF
/* Sidebar font size */
.monaco-workbench .part.sidebar {
    font-size: 15px !important;
}
/* File and folder names in Explorer */
.monaco-workbench .explorer-viewlet .monaco-list-row {
    font-size: 15px !important;
}
EOF

# ⚙️ Update settings.json
SETTINGS_FILE="$HOME/.config/Code/User/settings.json"
echo "🛠️ Updating settings.json..."
mkdir -p "$(dirname "$SETTINGS_FILE")"

# If settings.json doesn't exist, create it
if [ ! -f "$SETTINGS_FILE" ]; then
  echo "{}" > "$SETTINGS_FILE"
fi

# Use jq to safely update settings.json
if command -v jq >/dev/null; then
  TMP_FILE=$(mktemp)
  jq \
    --arg css "file://$CSS_FILE" \
    '. + {
      "vscode_custom_css.imports": [$css],
      "vscode_custom_css.policy": true
    }' "$SETTINGS_FILE" > "$TMP_FILE" && mv "$TMP_FILE" "$SETTINGS_FILE"
else
  echo "⚠️ jq not found, appending settings manually."
  echo 'Please manually add this to your settings.json if needed:'
  echo '  "vscode_custom_css.imports": ["file://'"$CSS_FILE"'"],'
  echo '  "vscode_custom_css.policy": true'
fi

# 🔗 Add alias to shell config
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

# 🧼 Clean up
rm /tmp/vscode.tar.gz

# 🚀 Launch!
echo "🚀 Launching VS Code with custom CSS support!"
$INSTALL_DIR/code --enable-proposed-api be5invis.vscode-custom-css

echo "🎉 All done! Run 'vscodecss' next time to launch!"
