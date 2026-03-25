#!/usr/bin/env bash
#
# sync_vscode_settings.sh
# Purpose: Merge a project's .vscode/settings.json into your global VS Code user settings
# Platform: Rocky Linux 9 / any modern Linux
# Author: Groucho (2025-10-27)
#

# Exit on error
set -e

# --- CONFIGURATION --------------------------------------------------------
PROJECT_VSCODE_DIR="${1:-$(pwd)/.vscode}"
PROJECT_SETTINGS="$PROJECT_VSCODE_DIR/settings.json"
USER_SETTINGS_DIR="$HOME/.config/Code/User"
USER_SETTINGS="$USER_SETTINGS_DIR/settings.json"

# --- CHECKS ---------------------------------------------------------------
if [ ! -f "$PROJECT_SETTINGS" ]; then
  echo "❌ No .vscode/settings.json found in: $PROJECT_VSCODE_DIR"
  echo "Usage: $0 /path/to/project"
  exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "📦 Installing jq (required for JSON merge)..."
  sudo dnf install -y jq
fi

# --- BACKUP EXISTING USER SETTINGS ----------------------------------------
mkdir -p "$USER_SETTINGS_DIR"
if [ -f "$USER_SETTINGS" ]; then
  BACKUP="$USER_SETTINGS_DIR/settings.json.backup.$(date +%F-%H%M%S)"
  cp "$USER_SETTINGS" "$BACKUP"
  echo "🗄️  Backup saved to: $BACKUP"
else
  echo "ℹ️  No existing global settings found, creating a new one."
  echo "{}" > "$USER_SETTINGS"
fi

# --- MERGE PROJECT SETTINGS INTO USER SETTINGS ----------------------------
echo "🔄 Merging project settings into global user settings..."
jq -s '.[0] * .[1]' "$USER_SETTINGS" "$PROJECT_SETTINGS" \
  > "$USER_SETTINGS_DIR/settings.merged.json"

mv "$USER_SETTINGS_DIR/settings.merged.json" "$USER_SETTINGS"

# --- CONFIRMATION --------------------------------------------------------
echo "✅ Merge complete!"
echo "Global settings now updated: $USER_SETTINGS"
echo
echo "💡 Tip: You can re-run this script any time after editing your project .vscode/settings.json."
