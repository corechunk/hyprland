#!/usr/bin/env bash
# v2_segment_3_download_debs.sh
# Reads /tmp/hypr_target_deps.txt and downloads all matching .deb files
# from snapshot.debian.org into ~/hypr_debs_v2/
# Idempotent: skips already-downloaded files.

set -euo pipefail
SNAP="https://snapshot.debian.org"
WORK_DIR="${HOME}/hypr_debs_v2"
INPUT_FILE="/tmp/hypr_target_deps.txt"

C='\033[0;36m'; G='\033[0;32m'; Y='\033[1;33m'; R='\033[0;31m'; B='\033[1m'; X='\033[0m'
info() { echo -e "${C}[INFO]${X} $*"; }
ok()   { echo -e "${G}[ OK ]${X} $*"; }
warn() { echo -e "${Y}[WARN]${X} $*"; }
err()  { echo -e "${R}[ERR ]${X} $*" >&2; }

echo -e "${B}=================================================="
echo " STEP 3: Download .deb Files from Snapshot"
echo -e "==================================================${X}"

if [[ ! -f "$INPUT_FILE" ]]; then
  err "Input file not found: $INPUT_FILE"
  err "Run v2_segment_2_resolve_deps.sh first."
  exit 1
fi

mkdir -p "$WORK_DIR"
info "Download directory: $WORK_DIR"

FAILED=()
DOWNLOADED=()
SKIPPED=()

# --- Resolve download URL for a given package + version ---
get_deb_url() {
  local pkg="$1" ver="$2"
  local ver_noepoch="${ver#*:}"

  for try_ver in "$ver_noepoch" "$ver"; do
    result=$(curl -sf --max-time 20 "${SNAP}/mr/binary/${pkg}/${try_ver}/binfiles" 2>/dev/null || true)
    [[ -n "$result" && "$result" != *'"result":[]'* ]] && break
    result=""
  done
  [[ -z "$result" ]] && return 1

  hash=$(echo "$result" | python3 -c "
import sys,json
d=json.load(sys.stdin)
files=d.get('result',[])
amd64=[f for f in files if f.get('architecture')=='amd64']
print((amd64 or files)[0]['hash'] if (amd64 or files) else '')
" 2>/dev/null || true)
  [[ -z "$hash" ]] && return 1

  file_info=$(curl -sf --max-time 20 "${SNAP}/mr/file/${hash}/info" 2>/dev/null || true)
  [[ -z "$file_info" ]] && return 1

  read -r fpath fname fseen farchive < <(echo "$file_info" | python3 -c "
import sys,json
d=json.load(sys.stdin)
r=d.get('result',[])
if r:
    i=r[0]
    print(i.get('path','').lstrip('/'), i.get('name',''), i.get('first_seen',''), i.get('archive_name','debian'))
else:
    print('','','','debian')
" 2>/dev/null || echo "   debian")

  [[ -z "$fname" || -z "$fseen" ]] && return 1

  echo "${SNAP}/archive/${farchive}/${fseen}/${fpath}/${fname}"
}

# --- Read deps map and download each ---
echo ""
while IFS='=' read -r pkg ver; do
  # Skip comment and blank lines
  [[ "$pkg" =~ ^#.*$ || -z "$pkg" || -z "$ver" ]] && continue
  pkg="${pkg// /}"
  ver="${ver// /}"

  info "Processing: ${pkg} = ${ver}"

  DEB_URL=$(get_deb_url "$pkg" "$ver" 2>/dev/null || true)
  if [[ -z "$DEB_URL" ]]; then
    warn "  SKIP — could not resolve download URL for $pkg $ver"
    FAILED+=("$pkg")
    continue
  fi

  FNAME=$(basename "$DEB_URL")
  OUT="${WORK_DIR}/${FNAME}"

  # Idempotent: skip if file already exists and is non-zero
  if [[ -f "$OUT" && -s "$OUT" ]]; then
    ok "  Already downloaded: $FNAME (skipping)"
    SKIPPED+=("$pkg")
    continue
  fi

  info "  Downloading: $FNAME"
  if wget -q --show-progress "$DEB_URL" -O "$OUT" 2>&1; then
    if [[ -f "$OUT" && -s "$OUT" ]]; then
      ok "  Saved: $OUT"
      DOWNLOADED+=("$pkg")
    else
      warn "  Downloaded but file is empty/corrupt: $FNAME"
      rm -f "$OUT"
      FAILED+=("$pkg")
    fi
  else
    warn "  Download failed: $pkg"
    rm -f "$OUT"
    FAILED+=("$pkg")
  fi
done < "$INPUT_FILE"

echo ""
echo -e "${B}================================================${X}"
ok "Downloaded:  ${#DOWNLOADED[@]} package(s)"
[[ ${#SKIPPED[@]} -gt 0 ]] && info "Skipped (cached): ${#SKIPPED[@]} — ${SKIPPED[*]}"
[[ ${#FAILED[@]} -gt 0 ]] && warn "Failed: ${FAILED[*]}"
echo ""
info "All .deb files in: $WORK_DIR"
ls -1 "$WORK_DIR"/*.deb 2>/dev/null | sed 's|.*/||'
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NEXT="$SCRIPT_DIR/v2_segment_4_install_debs.sh"

read -p "Run next step (v2_segment_4_install_debs.sh) to install? [Y/n]: " RUN_NEXT
RUN_NEXT="${RUN_NEXT:-Y}"
if [[ "$RUN_NEXT" =~ ^[Yy]$ ]]; then
  bash "$NEXT"
else
  echo "Skipped. Run manually:"
  echo "  $NEXT"
fi
