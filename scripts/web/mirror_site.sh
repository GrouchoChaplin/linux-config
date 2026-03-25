#!/bin/bash
# Mirror a website locally with timestamp, logging, depth limit, cleanup, and 'latest' symlink
# Usage:
#   ./mirror_site.sh <website_url> [-d <download_directory>] [--no-browser]
#
# Example:
#   ./mirror_site.sh https://www.spurgeongems.org/ -d /run/media/$USER/MasterBackup/Websites --no-browser

set -e

# --- Configuration ---
DEFAULT_BASE="$HOME/WebsiteMirror"
DEPTH=3
RETENTION_DAYS=30   # Delete mirrors older than this

# --- Argument parsing ---
if [ -z "$1" ]; then
  echo "Usage: $0 <website_url> [-d <download_directory>] [--no-browser]"
  exit 1
fi

URL="$1"
shift
CUSTOM_DIR=""
NO_BROWSER=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--dir)
      CUSTOM_DIR="$2"
      shift 2
      ;;
    --no-browser)
      NO_BROWSER=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 <website_url> [-d <download_directory>] [--no-browser]"
      exit 1
      ;;
  esac
done

# --- Derived paths ---
TIMESTAMP=$(date +%F-%H%M%S)
BASE_DIR="${CUSTOM_DIR:-$DEFAULT_BASE}"
TARGET_BASE="$(echo "$URL" | sed 's~https\?://~~; s~/~_~g')"
TARGET_DIR="$BASE_DIR/${TARGET_BASE}_$TIMESTAMP"
LOG_FILE="$TARGET_DIR/mirror_$TIMESTAMP.log"
LATEST_LINK="$BASE_DIR/${TARGET_BASE}_latest"

mkdir -p "$TARGET_DIR"

# --- Mirror start ---
echo "[$(date +'%F %T')] Starting mirror of $URL"
echo "Target: $TARGET_DIR"
echo "Log: $LOG_FILE"
echo

wget --mirror \
     --convert-links \
     --adjust-extension \
     --page-requisites \
     --no-parent \
     --timestamping \
     --retry-connrefused \
     --wait=1 \
     --random-wait \
     --level=$DEPTH \
     --progress=bar:force \
     -e robots=off \
     -P "$TARGET_DIR" \
     "$URL" 2>&1 | tee "$LOG_FILE"

if [ $? -eq 0 ]; then
  echo
  echo "✅ Mirror completed successfully!"

  # Update 'latest' symlink
  ln -sfn "$TARGET_DIR" "$LATEST_LINK"
  echo "🔗 Updated symlink: $LATEST_LINK → $TARGET_DIR"

  # Open mirrored site (unless --no-browser or no GUI)
  if [ "$NO_BROWSER" = false ]; then
    INDEX_FILE=$(find "$TARGET_DIR" -type f -name "index.html" | head -n 1)
    if [ -n "$INDEX_FILE" ]; then
      if command -v xdg-open >/dev/null 2>&1 && [ -n "$DISPLAY" ]; then
        echo "Opening mirrored site..."
        xdg-open "$INDEX_FILE" >/dev/null 2>&1 || true
      else
        echo "GUI not detected; skipping auto-open."
      fi
    else
      echo "⚠️  No index.html found. Check the log file for details."
    fi
  else
    echo "🖥️  Browser launch disabled (--no-browser)."
  fi
else
  echo "❌ Mirror failed! See log: $LOG_FILE"
  exit 1
fi

# --- Cleanup old mirrors ---
echo
echo "🧹 Cleaning up mirrors older than $RETENTION_DAYS days..."
find "$BASE_DIR" -maxdepth 1 -type d -mtime +$RETENTION_DAYS -name "${TARGET_BASE}_*" -exec rm -rf {} \; -print || true
echo "Cleanup complete."
