#!/bin/bash
# mirror_openbible.sh
# Usage: ./mirror_openbible.sh [full|articles] [local|icloud] [zip]

MODE="$1"
TARGET="$2"
DOZIP="$3"
LOGFILE="httrack.log"

if [ -z "$MODE" ]; then
  echo "Usage: $0 [full|articles] [local|icloud] [zip]"
  exit 1
fi

if [ -z "$TARGET" ]; then
  TARGET="local"
fi

if ! command -v httrack &> /dev/null; then
  echo "Error: httrack not found. Install it with:"
  echo "  sudo dnf install httrack"
  exit 1
fi

# Set base output folder
case "$TARGET" in
  local)
    BASEDIR="."
    ;;
  icloud)
    # macOS default iCloud Drive location
    if [ -d "$HOME/Library/Mobile Documents/com~apple~CloudDocs" ]; then
      BASEDIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
    elif [ -d "$HOME/iCloudDrive" ]; then
      BASEDIR="$HOME/iCloudDrive"
    elif [ -d "$HOME/iCloud" ]; then
      BASEDIR="$HOME/iCloud"
    else
      echo "Error: Could not find iCloud Drive folder."
      echo "Please edit the script to point to your iCloud location."
      exit 1
    fi
    ;;
  *)
    echo "Invalid target: $TARGET"
    echo "Usage: $0 [full|articles] [local|icloud] [zip]"
    exit 1
    ;;
esac

# Select mode
case "$MODE" in
  full)
    OUTDIR="$BASEDIR/openbible_full"
    echo "Starting FULL site mirror of openbible.com..."
    httrack "https://openbible.com/" \
      -O "$OUTDIR" \
      "+https://openbible.com/*" \
      "-*" \
      --mirror \
      --depth=5 \
      --near \
      --sockets=4 \
      --disable-security-limits \
      --keep-alive \
      --verbose \
      --index \
      --continue \
      --extra-log "$LOGFILE"
    ;;

  articles)
    OUTDIR="$BASEDIR/openbible_articles"
    echo "Starting ARTICLES + COMMENTARIES mirror of openbible.com..."
    httrack "https://openbible.com/" \
      -O "$OUTDIR" \
      "+https://openbible.com/topics/*" \
      "+https://openbible.com/articles/*" \
      "+https://openbible.com/blog/*" \
      "-*" \
      --mirror \
      --depth=3 \
      --near \
      --sockets=4 \
      --disable-security-limits \
      --keep-alive \
      --verbose \
      --index \
      --continue \
      --extra-log "$LOGFILE"
    ;;

  *)
    echo "Invalid option: $MODE"
    echo "Usage: $0 [full|articles] [local|icloud] [zip]"
    exit 1
    ;;
esac

# Optionally zip the output
if [ "$DOZIP" == "zip" ]; then
  echo "Creating ZIP archive..."
  cd "$(dirname "$OUTDIR")" || exit 1
  zip -r "$(basename "$OUTDIR").zip" "$(basename "$OUTDIR")"
  echo "ZIP archive created: $(basename "$OUTDIR").zip"
fi

echo "Done. Open the mirrored site by opening index.html in $OUTDIR."
