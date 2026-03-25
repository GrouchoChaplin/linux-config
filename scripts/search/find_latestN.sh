#!/usr/bin/env bash
# find_latestN.sh — newest-N file finder with wildcard support + optional plocate DB refresh
#
# Works two ways:
#   1) If plocate is installed and its DB is fresh -> near-instant candidate list
#   2) Otherwise falls back to 'find' (slower, but always available)
#
# Usage:
#   ./find_latestN.sh -p "<glob>" -n <N> [--basename] [--maxc M] [--update-db] [roots...]
#   ./find_latestN.sh -p "*.nc" -n 10 --update-db / /home /mnt/data
#
# Options:
#   -p/--pattern   Shell-style glob (e.g., "*.log", "backup_??.tar.gz")
#   -n/--count     How many newest results to print
#   --basename     Match the pattern on the basename only (plocate path filter still applied)
#   --maxc M       Max candidates to stat (default 100000); lower for huge systems to go faster
#   --update-db    Run 'sudo updatedb' (plocate) before searching; writes /var/lib/plocate/plocate.db
#   -h/--help      Show help
#
# Output columns:
#   TIMESTAMP(size bytes)  PATH
#
# Notes:
#   • For plocate to work, its DB must exist and be readable by your user.
#     Manual refresh:  sudo /usr/bin/updatedb -o /var/lib/plocate/plocate.db
#   • If your large disks live under /mnt or /media, make sure those aren’t pruned in /etc/updatedb.conf.

set -euo pipefail

usage() {
  sed -n '1,40p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

PATTERN="" COUNT="" BASENAME=0 MAXC=100000 UPDATE_DB=0
ROOTS=()

# --- Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--pattern) PATTERN="${2:-}"; shift 2;;
    -n|--count)   COUNT="${2:-}"; shift 2;;
    --basename)   BASENAME=1; shift;;
    --maxc)       MAXC="${2:-}"; shift 2;;
    --update-db)  UPDATE_DB=1; shift;;
    -h|--help)    usage;;
    --) shift; break;;
    -*) echo "Unknown option: $1" >&2; usage;;
    *)  ROOTS+=("$1"); shift;;
  esac
done

[[ -z "$PATTERN" || -z "$COUNT" ]] && { echo "Error: -p <glob> and -n <N> are required."; usage; }

# Default roots → "/"
[[ ${#ROOTS[@]} -eq 0 ]] && ROOTS=( / )

# Normalize roots to absolute paths without trailing slashes (except /)
norm_roots=()
for r in "${ROOTS[@]}"; do
  r="$(readlink -f -- "$r" 2>/dev/null || printf '%s' "$r")"
  [[ "$r" != "/" ]] && r="${r%/}"
  norm_roots+=("$r")
done
ROOTS=("${norm_roots[@]}")

# Turn a shell glob into a regex that matches the FULL PATH by default.
glob_to_regex() {
  local g="$1"
  # Escape regex specials
  g="${g//\\/\\\\}"; g="${g//./\\.}"; g="${g//+/\\+}"; g="${g//(/\\(}"; g="${g//)/\\)}"
  g="${g//[/\\[}";  g="${g//]/\\]}";  g="${g//\{/\\{}"; g="${g//\}/\\}}"; g="${g//^/\\^}"
  g="${g//\$/\\$}"; g="${g//|/\\|}"
  # Convert globs
  g="${g//\*/.*}"; g="${g//\?/.}"
  printf '%s' "$g"
}

REGEX="$(glob_to_regex "$PATTERN")"

# Build an awk condition that keeps only paths under the given roots
awk_prefix_filter='
BEGIN {
  split("'"$(printf "%q " "${ROOTS[@]}")"'", R, " ");
  for (i in R) { root = R[i]; gsub(/\\040/, " ", root); PREF[++n] = root; }
}
{
  p = $0; keep = 0;
  for (i = 1; i <= n; ++i) {
    root = PREF[i];
    if (root == "/") { keep = 1; break; }
    if (index(p, root) == 1 && (length(p) == length(root) || substr(p, length(root)+1, 1) == "/")) { keep = 1; break; }
  }
  if (keep) print;
}'

# NUL-safe filter to roots and (optionally) to basename glob
filter_candidates() {
  local do_basename="$1"
  awk -v RS='\0' -v ORS='\0' "$awk_prefix_filter" | \
  if [[ "$do_basename" -eq 1 ]]; then
    while IFS= read -r -d '' p; do
      b=${p##*/}
      if [[ $b == $PATTERN ]]; then printf '%s\0' "$p"; fi
    done
  else
    cat
  fi
}

# Emit mtime|human|size|path for each input path (NUL-delimited input)
stat_lines() {
  xargs -0 stat -c '%Y|%y|%s|%n' 2>/dev/null
}

# --- Optional: refresh plocate DB
run_update_db() {
  if ! command -v plocate >/dev/null 2>&1; then
    echo "[WARN] --update-db requested but plocate not found; skipping." >&2
    return 0
  fi

  # 1) Prefer plocate's updater if present
  if [[ -x /usr/libexec/locate/updatedb.plocate ]]; then
    echo "[INFO] Refreshing with updatedb.plocate"
    sudo /usr/libexec/locate/updatedb.plocate -o /var/lib/plocate/plocate.db && return 0
  fi
  if [[ -x /usr/bin/updatedb ]]; then
    # Heuristic: if this updatedb is plocate's, it will produce a readable DB
    echo "[INFO] Refreshing with /usr/bin/updatedb"
    if sudo /usr/bin/updatedb -o /var/lib/plocate/plocate.db; then
      # quick probe
      plocate -d /var/lib/plocate/plocate.db -r '^/$' >/dev/null 2>&1 && return 0
    fi
  fi

  # 2) Fallback: build mlocate DB then convert with plocate-build
  echo "[INFO] Building mlocate DB then converting with plocate-build"
  sudo /usr/sbin/updatedb
  sudo plocate-build /var/lib/mlocate/mlocate.db /var/lib/plocate/plocate.db
}


# ----------- Main -----------
if (( UPDATE_DB )); then
  run_update_db
fi

if command -v plocate >/dev/null 2>&1; then
  # Use plocate for fast candidate enumeration
  if [[ "$BASENAME" -eq 1 ]]; then
    plocate -0 --existing --regexp "$REGEX" \
      | filter_candidates 1 \
      | head -z -n "$MAXC" \
      | stat_lines \
      | sort -t'|' -nr -k1,1 \
      | head -n "$COUNT" \
      | cut -d'|' -f2-4
  else
    plocate -0 --existing --regexp "$REGEX" \
      | filter_candidates 0 \
      | head -z -n "$MAXC" \
      | stat_lines \
      | sort -t'|' -nr -k1,1 \
      | head -n "$COUNT" \
      | cut -d'|' -f2-4
  fi
else
  # Fallback to find (slower; walks disks)
  find "${ROOTS[@]}" \
    \( -path /proc -o -path /sys -o -path /run -o -path /dev \) -prune -o \
    -type f -name "$PATTERN" -print0 \
    | head -z -n "$MAXC" \
    | stat_lines \
    | sort -t'|' -nr -k1,1 \
    | head -n "$COUNT" \
    | cut -d'|' -f2-4
fi
