#!/usr/bin/env bash
# test_restore_rocky8_repo.sh
# Test version of restore_rocky8_repo.sh
# Allows specifying alternate dest_dir (for .repo) and gpg_dir (for key)

set -e

usage() {
  echo "Usage: $0 [--dest-dir DIR] [--gpg-dir DIR]"
  echo
  echo "Defaults:"
  echo "  dest-dir: ./test_repos"
  echo "  gpg-dir : ./test_gpg"
  exit 1
}

# --- Default values ---
DEST_DIR="./test_repos"
GPG_DIR="./test_gpg"

# --- Parse args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest-dir)
      DEST_DIR="$2"
      shift 2
      ;;
    --gpg-dir)
      GPG_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# --- Required files ---
REPO_FILE="rocky8.repo"
GPG_KEY="RPM-GPG-KEY-rockyofficial"

# --- Validate files ---
if [[ ! -f "$REPO_FILE" ]]; then
  echo "❌ Error: $REPO_FILE not found."
  exit 1
fi

if [[ ! -f "$GPG_KEY" ]]; then
  echo "❌ Error: $GPG_KEY not found."
  exit 1
fi

# --- Create test directories ---
mkdir -p "$DEST_DIR" "$GPG_DIR"

# --- Copy files ---
echo "==> Copying repo file to $DEST_DIR..."
cp -f "$REPO_FILE" "$DEST_DIR/rocky8.repo"
chmod 644 "$DEST_DIR/rocky8.repo"

echo "==> Copying GPG key to $GPG_DIR..."
cp -f "$GPG_KEY" "$GPG_DIR/RPM-GPG-KEY-rockyofficial"
chmod 644 "$GPG_DIR/RPM-GPG-KEY-rockyofficial"

# --- Show simulated system actions ---
echo
echo "==> Simulating DNF cache rebuild (skipped in test mode)"
echo "   sudo dnf clean all"
echo "   sudo dnf makecache"
echo "   sudo dnf repolist"
echo

echo "✅ Test restore complete."
echo "   Repo file copied to: $DEST_DIR"
echo "   GPG key copied to:   $GPG_DIR"
