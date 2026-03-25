#!/usr/bin/env bash
set -euo pipefail

# Where to put the mirror (default: ./openbible_audio)
OUTDIR="${1:-openbible_audio}"

# Folders to include under https://openbible.com
# FOLDERS=(
#   "/audio/gilbert_books"
#   "/audio/hays_books"
#   "/audio/kjv_books"
#   "/audio/msb"
#   "/audio/msb_books"
#   "/audio/souer_books"
# )

FOLDERS=(
  "/audio/msb"
  "/audio/msb_books"
)

BASE="https://openbible.com"
START_URL="${BASE}/audio/"

# Join FOLDERS by comma for --include-directories
INCLUDE_LIST="$(IFS=, ; echo "${FOLDERS[*]}")"

mkdir -p "$OUTDIR"
cd "$OUTDIR"

# Mirror just those folders and common audio-related files
wget -c -r -np -nH --cut-dirs=1 \
  --domains=openbible.com \
  --include-directories="$INCLUDE_LIST" \
  -A mp3,m4a,ogg,wav,m3u,txt,html \
  --timestamping --wait=1 --random-wait \
  "$START_URL"


