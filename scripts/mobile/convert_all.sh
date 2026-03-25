#!/bin/bash
# --------------------------------------------------------------------
# convert_all.sh
# Convert all WAV files in the current folder to MP3 and MP4
# --------------------------------------------------------------------

set -e

shopt -s nullglob
FILES=(*.wav)

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "❌ No WAV files found in current directory."
  exit 1
fi

for f in "${FILES[@]}"; do
  BASENAME="${f%.*}"
  echo "🎧 Converting $f → ${BASENAME}.mp3 ..."
  ffmpeg -y -i "$f" -codec:a libmp3lame -qscale:a 2 "${BASENAME}.mp3"

  echo "🎬 Converting $f → ${BASENAME}.mp4 ..."
  ffmpeg -y -loop 1 -f lavfi -i color=c=black:s=1280x720:d=1 \
    -i "$f" -shortest \
    -c:v libx264 -preset veryfast -tune stillimage \
    -c:a aac -b:a 192k "${BASENAME}.mp4"
done

echo "✅ Done! Converted ${#FILES[@]} WAV files to MP3 and MP4."
