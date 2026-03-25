#!/bin/bash
# --------------------------------------------------------------------
# convert_one.sh
# Convert a single WAV file to MP3 and MP4 using ffmpeg
# Usage: ./convert_one.sh input.wav
# --------------------------------------------------------------------

set -e

INPUT="$1"

if [[ -z "$INPUT" || ! -f "$INPUT" ]]; then
  echo "❌ Usage: $0 /path/to/input.wav"
  exit 1
fi

BASENAME="${INPUT%.*}"

echo "🎧 Converting $INPUT → ${BASENAME}.mp3 ..."
ffmpeg -y -i "$INPUT" -codec:a libmp3lame -qscale:a 2 "${BASENAME}.mp3"

echo "🎬 Converting $INPUT → ${BASENAME}.mp4 ..."
# Create a simple static-black video background for the audio
ffmpeg -y -loop 1 -f lavfi -i color=c=black:s=1280x720:d=1 \
  -i "$INPUT" -shortest \
  -c:v libx264 -preset veryfast -tune stillimage \
  -c:a aac -b:a 192k "${BASENAME}.mp4"

echo "✅ Done!  Created:"
ls -1 "${BASENAME}.mp3" "${BASENAME}.mp4"
