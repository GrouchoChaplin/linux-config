#!/usr/bin/env bash
# split_rocky8_repo.sh (fixed version)
# Splits a combined rocky8.repo into individual .repo files
# Usage: ./split_rocky8_repo.sh /path/to/rocky8.repo [output_dir]

set -e

INPUT_FILE="${1:-./rocky8.repo}"
OUTPUT_DIR="${2:-./split_repos}"

if [[ ! -f "$INPUT_FILE" ]]; then
  echo "❌ Error: $INPUT_FILE not found."
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "==> Splitting $INPUT_FILE into individual repo files in $OUTPUT_DIR"

awk -v outdir="$OUTPUT_DIR" '
  /^\[.*\]/ {
    if (outfile != "") close(outfile)
    name=$0
    gsub(/^\[|\]$/, "", name)
    capname=toupper(substr(name,1,1)) substr(name,2)
    outfile = outdir "/Rocky-" capname ".repo"
    print "# Generated from rocky8.repo" > outfile
    print $0 >> outfile
    next
  }
  outfile != "" { print $0 >> outfile }
' "$INPUT_FILE"

echo "✅ Done. Created files:"
ls -1 "$OUTPUT_DIR"/Rocky-*.repo 2>/dev/null || echo "(no repo files created)"
