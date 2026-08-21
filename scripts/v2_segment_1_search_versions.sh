#!/usr/bin/env bash
# v2_segment_1_search_versions.sh
# Search all available Hyprland versions on snapshot.debian.org and pick one.

set -euo pipefail
SNAP="https://snapshot.debian.org"

echo "=================================================="
echo " STEP 1: Search & Select Hyprland Target Version"
echo "=================================================="
echo "Fetching available Hyprland versions from Snapshot..."

VERSIONS=($(curl -sf "${SNAP}/mr/binary/hyprland/" | python3 -c "
import sys, json
data = json.load(sys.stdin)
for r in data.get('result', []):
    print(r['binary_version'])
" 2>/dev/null | head -15))

if [[ ${#VERSIONS[@]} -eq 0 ]]; then
  echo "Error: Could not fetch Hyprland versions from Snapshot." >&2
  exit 1
fi

echo ""
echo "Available Hyprland Versions (newest to oldest):"
for i in "${!VERSIONS[@]}"; do
  printf " [%2d] %s\n" "$((i+1))" "${VERSIONS[$i]}"
done

echo ""
if [[ -n "${1:-}" ]]; then
  SELECTED_VER="$1"
  echo "Selected version from argument: $SELECTED_VER"
else
  read -p "Select version number [1-${#VERSIONS[@]}] (default 1): " CHOICE
  CHOICE="${CHOICE:-1}"
  INDEX=$((CHOICE-1))
  SELECTED_VER="${VERSIONS[$INDEX]}"
  echo "Selected version: $SELECTED_VER"
fi

echo "$SELECTED_VER" > /tmp/hypr_selected_version.txt
echo ""
echo "Saved selected version to /tmp/hypr_selected_version.txt"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NEXT="$SCRIPT_DIR/v2_segment_2_resolve_deps.sh"

read -p "Run next step (v2_segment_2_resolve_deps.sh) with version '$SELECTED_VER'? [Y/n]: " RUN_NEXT
RUN_NEXT="${RUN_NEXT:-Y}"
if [[ "$RUN_NEXT" =~ ^[Yy]$ ]]; then
  bash "$NEXT" "$SELECTED_VER"
else
  echo "Skipped. Run manually:"
  echo "  $NEXT $SELECTED_VER"
fi
