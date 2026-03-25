#!/usr/bin/env bash
#
# reset_vscode_cpp_env.sh
# Purpose: Reset all VS Code extensions and install a clean C++/CMake/clangd setup
# Author: Groucho (2025-10-27)
#

set -e

echo "⚙️  VS Code C++ Environment Reset & Minimal Setup"

# ---------------------------------------------------------------------------
# Confirm before wiping existing extensions
# ---------------------------------------------------------------------------
read -rp "This will uninstall ALL existing VS Code extensions. Continue? (y/N): " yn
case $yn in
  [Yy]*) ;;
  *) echo "❌  Cancelled."; exit 0 ;;
esac

# ---------------------------------------------------------------------------
# Check for 'code' command
# ---------------------------------------------------------------------------
if ! command -v code >/dev/null 2>&1; then
  echo "❌  VS Code CLI 'code' not found. Open VS Code and run:"
  echo "    Command Palette → 'Shell Command: Install code command in PATH'"
  exit 1
fi

# ---------------------------------------------------------------------------
# Uninstall all currently installed extensions
# ---------------------------------------------------------------------------
echo "🧹  Uninstalling all existing extensions..."
INSTALLED=$(code --list-extensions)
if [ -n "$INSTALLED" ]; then
  echo "$INSTALLED" | while read -r ext; do
    echo "   ➤ Removing $ext ..."
    code --uninstall-extension "$ext" --force || true
  done
else
  echo "   (No extensions installed)"
fi

# ---------------------------------------------------------------------------
# Ask whether to install minimal or developer pack
# ---------------------------------------------------------------------------
echo
echo "Choose setup type:"
echo "  1) Minimal   – clangd + CMake Tools only"
echo "  2) Developer – includes GitLens, ErrorLens, themes, icons, JSON helpers"
read -rp "Select [1/2]: " mode

# ---------------------------------------------------------------------------
# Common essential extensions
# ---------------------------------------------------------------------------
BASE_EXTS=(
  "llvm-vs-code-extensions.vscode-clangd"  # clangd language server
  "ms-vscode.cmake-tools"                  # CMake integration
  "ms-vscode.cpptools-extension-pack"      # Debug adapter & utilities
)

# ---------------------------------------------------------------------------
# Developer pack extras
# ---------------------------------------------------------------------------
DEV_EXTS=(
  "eamodio.gitlens"                        # GitLens
  "usernamehw.errorlens"                   # Inline error highlights
  "pkief.material-icon-theme"              # Icon theme
  "esbenp.prettier-vscode"                 # Formatter
  "bierner.markdown-preview-github-styles" # Markdown preview
  "zainchen.json"                          # JSON syntax helper
)

# ---------------------------------------------------------------------------
# Install clangd if missing
# ---------------------------------------------------------------------------
if ! command -v clangd >/dev/null 2>&1; then
  echo "📦  Installing clang-tools-extra (for clangd)..."
  sudo dnf install -y clang clang-tools-extra
fi

# ---------------------------------------------------------------------------
# Install selected extensions
# ---------------------------------------------------------------------------
echo "📦  Installing VS Code extensions..."
EXTS_TO_INSTALL=("${BASE_EXTS[@]}")
if [ "$mode" = "2" ]; then
  EXTS_TO_INSTALL+=("${DEV_EXTS[@]}")
fi

for ext in "${EXTS_TO_INSTALL[@]}"; do
  echo "   ➤ Installing $ext ..."
  code --install-extension "$ext" --force
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo
echo "✅  Setup complete!"
echo "Installed extensions:"
code --list-extensions

echo
if [ "$mode" = "2" ]; then
  echo "✨ Developer Pack installed:"
  echo "   • clangd + CMake Tools"
  echo "   • GitLens, ErrorLens, Icons, Prettier, Markdown/JSON tools"
else
  echo "✨ Minimal Pack installed:"
  echo "   • clangd + CMake Tools only"
fi

echo
echo "💡 Tip: Add your project .vscode/settings.json from earlier for clangd integration."
