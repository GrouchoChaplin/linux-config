#!/usr/bin/env bash
set -euo pipefail

# --- helper ---------------------------------------------------------------
log() { printf "\033[1;32m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }
die() { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*"; exit 1; }

need_cmd() { command -v "$1" >/dev/null 2>&1 || die "Missing required command: $1"; }

# --- detect distro ---------------------------------------------------------
ID=""; ID_LIKE=""
if [ -r /etc/os-release ]; then
  # shellcheck disable=SC1091
  . /etc/os-release
  ID="${ID:-}"; ID_LIKE="${ID_LIKE:-}"
else
  die "Cannot detect distro (no /etc/os-release)."
fi

log "Detected: ID=${ID} ID_LIKE=${ID_LIKE}"

# --- install packages -------------------------------------------------------
install_pkgs() {
  case "$ID" in
    rocky|almalinux|rhel)
      need_cmd sudo
      # Enable CRB + EPEL (widely recommended on EL9) 
      # (per Rocky/EPEL docs, epel-release provides access to extra packages)
      sudo dnf -y install 'dnf-command(config-manager)' || true
      sudo dnf config-manager --set-enabled crb || true
      sudo dnf -y install epel-release || true
      sudo dnf -y install task timew || die "DNF install failed"
      ;;
    fedora)
      need_cmd sudo
      sudo dnf -y install task timew || die "DNF install failed"
      ;;
    debian|ubuntu|linuxmint|pop)
      need_cmd sudo
      sudo apt-get update -y
      sudo apt-get install -y taskwarrior timewarrior || die "APT install failed"
      ;;
    arch)
      need_cmd sudo
      sudo pacman -Sy --noconfirm task timew || die "Pacman install failed"
      ;;
    *)
      warn "Unknown distro. Attempting generic installers..."
      if command -v dnf >/dev/null; then
        sudo dnf -y install task timew || die "DNF install failed"
      elif command -v apt-get >/dev/null; then
        sudo apt-get update -y
        sudo apt-get install -y taskwarrior timewarrior || die "APT install failed"
      elif command -v pacman >/dev/null; then
        sudo pacman -Sy --noconfirm task timew || die "Pacman install failed"
      else
        die "No supported package manager found. Install Taskwarrior/Timewarrior manually."
      fi
      ;;
  esac
}

log "Installing Taskwarrior + Timewarrior ..."
install_pkgs

# --- ensure config dirs -----------------------------------------------------
TASK_DIR="${HOME}/.task"
TIMEW_DIR="${HOME}/.timewarrior"
HOOKS_DIR="${TASK_DIR}/hooks"
mkdir -p "${TASK_DIR}" "${TIMEW_DIR}" "${HOOKS_DIR}"

# --- write sensible defaults (non-destructive) ------------------------------
TASKRC="${HOME}/.taskrc"
if [ ! -f "${TASKRC}" ]; then
  log "Creating ${TASKRC}"
  cat >> "${TASKRC}" <<'EOF'
# Taskwarrior sensible defaults
include /usr/share/doc/task/rc/periodic-reports.rc 2>/dev/null
uda.project.type=string
report.next.columns=id,project,priority,due,description
report.next.sort=due+,priority-,project+
confirmation=off
EOF
else
  log "Found existing ${TASKRC} (leaving as-is)"
fi

TIMEW_CFG="${TIMEW_DIR}/timewarrior.cfg"
if [ ! -f "${TIMEW_CFG}" ]; then
  log "Creating ${TIMEW_CFG}"
  cat >> "${TIMEW_CFG}" <<'EOF'
# Timewarrior sensible defaults
# Exclude weekends from charts (purely visual; does not block tracking)
exclusion.weekdays=Saturday,Sunday
# Example: set default reports to show by day
reports.range=day
EOF
else
  log "Found existing ${TIMEW_CFG} (leaving as-is)"
fi

# --- locate the on-modify.timewarrior hook ----------------------------------
# Common locations per Timewarrior docs; distro packages may vary. 
CANDIDATES=(
  "/usr/share/doc/timew/ext/on-modify.timewarrior"
  "/usr/local/share/doc/timew/ext/on-modify.timewarrior"
  "/usr/share/timew/extra/on-modify.timewarrior"
  "/usr/share/doc/timewarrior/examples/on-modify.timewarrior"
  "/usr/share/doc/timewarrior*/examples/on-modify.timewarrior"
)

FOUND=""
for p in "${CANDIDATES[@]}"; do
  for f in $p; do
    [ -f "$f" ] && FOUND="$f" && break
  done
  [ -n "$FOUND" ] && break
done

if [ -z "$FOUND" ]; then
  # Fallback: ask rpm/dpkg for file list
  if command -v rpm >/dev/null; then
    rpm -ql timew 2>/dev/null | grep -E '/on-modify\.timewarrior$' && FOUND="$(rpm -ql timew | grep -E '/on-modify\.timewarrior$' | head -n1)"
  elif command -v dpkg-query >/dev/null; then
    dpkg-query -L timewarrior 2>/dev/null | grep -E '/on-modify\.timewarrior$' && FOUND="$(dpkg-query -L timewarrior | grep -E '/on-modify\.timewarrior$' | head -n1)"
  fi
fi

if [ -z "$FOUND" ]; then
  warn "Could not auto-locate on-modify.timewarrior. Integration will be skipped."
  warn "Check your package's docs to find it, then copy it to ${HOOKS_DIR}/ and chmod +x."
else
  log "Hook found: ${FOUND}"
  cp -f "${FOUND}" "${HOOKS_DIR}/on-modify.timewarrior"
  chmod +x "${HOOKS_DIR}/on-modify.timewarrior"
  log "Installed hook to ${HOOKS_DIR}/on-modify.timewarrior"
fi

# --- quick smoke test -------------------------------------------------------
log "Running diagnostics..."
task diagnostics >/dev/null 2>&1 || true
timew --version >/dev/null 2>&1 || true

echo
log "Done! Quick start:"
cat <<'EOT'
  # Add a task
  task add "Implement feature X" project:MyProj +dev priority:H

  # Start work (Timewarrior will start automatically via hook)
  task +LATEST start

  # Stop work
  task +LATEST stop

  # Mark done
  task +LATEST done

  # Review time this week
  timew summary :week

If the hook didn't start time automatically:
  - Ensure the hook exists and is executable:
      ls -l ~/.task/hooks/on-modify.timewarrior
  - See integration docs: timew help taskwarrior
EOT
