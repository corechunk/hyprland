#!/usr/bin/env bash
# v2_segment_6_hold_packages.sh
# Applies apt-mark hold to all packages resolved by
# v2_segment_2_resolve_deps.sh.
# Safe to re-run: reports current hold state before and after.

set -euo pipefail
INPUT_FILE="/tmp/hypr_target_deps.txt"

C='\033[0;36m'; G='\033[0;32m'; Y='\033[1;33m'; R='\033[0;31m'; B='\033[1m'; X='\033[0m'
info() { echo -e "${C}[INFO]${X} $*"; }
ok()   { echo -e "${G}[ OK ]${X} $*"; }
warn() { echo -e "${Y}[WARN]${X} $*"; }
err()  { echo -e "${R}[ERR ]${X} $*" >&2; }

echo -e "${B}=================================================="
echo " STEP 6: Hold All Packages via apt-mark"
echo -e "==================================================${X}"

if [[ ! -f "$INPUT_FILE" ]]; then
  err "Input file not found: $INPUT_FILE"
  err "Run v2_segment_2_resolve_deps.sh first."
  exit 1
fi

echo ""
info "Current hold status (before):"
apt-mark showhold 2>/dev/null | grep -iE 'hypr|aquamarine' || info "  (no hypr packages currently held)"
echo ""

HELD=()
FAILED=()

while IFS='=' read -r pkg ver; do
  [[ "$pkg" =~ ^#.*$ || -z "$pkg" || -z "$ver" ]] && continue
  pkg="${pkg// /}"; ver="${ver// /}"

  # Check package is installed before holding
  cur=$(dpkg-query -W -f='${Version}' "$pkg" 2>/dev/null || echo "")
  if [[ -z "$cur" ]]; then
    warn "  SKIP $pkg — not installed"
    continue
  fi

  if sudo apt-mark hold "$pkg" 2>/dev/null; then
    ok "  Held: $pkg (at $cur)"
    HELD+=("$pkg")
  else
    warn "  Failed to hold: $pkg"
    FAILED+=("$pkg")
  fi
done < "$INPUT_FILE"

echo ""
info "Current hold status (after):"
apt-mark showhold 2>/dev/null | grep -iE 'hypr|aquamarine' || true

echo ""
echo -e "${B}================================================${X}"
ok "Held:   ${#HELD[@]} package(s) — ${HELD[*]:-none}"
[[ ${#FAILED[@]} -gt 0 ]] && warn "Failed: ${FAILED[*]}"
echo ""
ok "All done! Your Hyprland ecosystem is fully locked."
echo ""
info "To verify: apt-mark showhold"
info "To unhold later: sudo apt-mark unhold \$(cat /tmp/hypr_target_deps.txt | grep -v '^#' | cut -d= -f1)"
