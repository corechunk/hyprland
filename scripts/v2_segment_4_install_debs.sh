#!/usr/bin/env bash
# v2_segment_4_install_debs.sh
# Reads /tmp/hypr_target_deps.txt for package names,
# applies apt-mark hold FIRST to protect all hypr packages,
# THEN installs all .deb files from ~/hypr_debs_v2/
# Safe to re-run: checks current installed versions first.

set -euo pipefail
WORK_DIR="${HOME}/hypr_debs_v2"
INPUT_FILE="/tmp/hypr_target_deps.txt"

C='\033[0;36m'; G='\033[0;32m'; Y='\033[1;33m'; R='\033[0;31m'; B='\033[1m'; X='\033[0m'
info() { echo -e "${C}[INFO]${X} $*"; }
ok()   { echo -e "${G}[ OK ]${X} $*"; }
warn() { echo -e "${Y}[WARN]${X} $*"; }
err()  { echo -e "${R}[ERR ]${X} $*" >&2; }

echo -e "${B}=================================================="
echo " STEP 4: Install .deb Files"
echo -e "==================================================${X}"

if [[ ! -f "$INPUT_FILE" ]]; then
  err "Input file not found: $INPUT_FILE"
  err "Run v2_segment_2_resolve_deps.sh first."
  exit 1
fi

shopt -s nullglob
DEB_FILES=("${WORK_DIR}"/*.deb)
shopt -u nullglob

if [[ ${#DEB_FILES[@]} -eq 0 ]]; then
  err "No .deb files found in $WORK_DIR"
  err "Run v2_segment_3_download_debs.sh first."
  exit 1
fi

# --- Read all package names from dep map ---
PKGS=()
while IFS='=' read -r pkg ver; do
  [[ "$pkg" =~ ^#.*$ || -z "$pkg" || -z "$ver" ]] && continue
  PKGS+=("${pkg// /}")
done < "$INPUT_FILE"

echo ""
info "Packages to be managed: ${PKGS[*]}"
echo ""

# --- CRITICAL: Apply holds BEFORE running apt ---
info "Applying apt-mark hold to all packages BEFORE installation..."
for pkg in "${PKGS[@]}"; do
  if dpkg -l "$pkg" &>/dev/null; then
    sudo apt-mark hold "$pkg" 2>/dev/null && ok "  Held: $pkg" || true
  fi
done
echo ""

# --- Check which packages already match target versions ---
info "Checking current installed versions vs targets..."
ALL_MATCH=true
while IFS='=' read -r pkg ver; do
  [[ "$pkg" =~ ^#.*$ || -z "$pkg" || -z "$ver" ]] && continue
  pkg="${pkg// /}"; ver="${ver// /}"
  cur=$(dpkg-query -W -f='${Version}' "$pkg" 2>/dev/null || echo "not-installed")
  if [[ "$cur" == "$ver" ]]; then
    ok "  Already at target: $pkg = $ver"
  else
    warn "  Needs install: $pkg (have: $cur  want: $ver)"
    ALL_MATCH=false
  fi
done < "$INPUT_FILE"

if [[ "$ALL_MATCH" == true ]]; then
  ok "All packages already at target versions. Nothing to install."
  echo ""
  info "Next step: Run ./v2_segment_5_pin_packages.sh"
  exit 0
fi

echo ""
info "Installing ${#DEB_FILES[@]} .deb file(s)..."
sudo dpkg -i "${WORK_DIR}"/*.deb || {
  warn "dpkg reported issues. Running apt-get -f install to fix non-hypr deps..."
  # Holds are already active so apt will NOT upgrade hypr packages
  sudo apt-get install -f -y
}

# --- Verify installed versions match targets ---
echo ""
info "Post-install version check:"
MISMATCH=()
while IFS='=' read -r pkg ver; do
  [[ "$pkg" =~ ^#.*$ || -z "$pkg" || -z "$ver" ]] && continue
  pkg="${pkg// /}"; ver="${ver// /}"
  cur=$(dpkg-query -W -f='${Version}' "$pkg" 2>/dev/null || echo "not-installed")
  if [[ "$cur" == "$ver" ]]; then
    ok "  $pkg = $cur"
  else
    warn "  MISMATCH: $pkg (have: $cur  want: $ver)"
    MISMATCH+=("$pkg")
  fi
done < "$INPUT_FILE"

echo ""
if [[ ${#MISMATCH[@]} -gt 0 ]]; then
  err "Version mismatches detected for: ${MISMATCH[*]}"
  err "Check if apt upgraded them despite holds."
  exit 1
else
  ok "All packages installed at correct target versions."
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NEXT="$SCRIPT_DIR/v2_segment_5_pin_packages.sh"

read -p "Run next step (v2_segment_5_pin_packages.sh) to write APT pin file? [Y/n]: " RUN_NEXT
RUN_NEXT="${RUN_NEXT:-Y}"
if [[ "$RUN_NEXT" =~ ^[Yy]$ ]]; then
  bash "$NEXT"
else
  echo "Skipped. Run manually:"
  echo "  $NEXT"
fi
