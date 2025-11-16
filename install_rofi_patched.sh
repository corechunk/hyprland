#!/bin/bash
set -e

echo "=== Installing dependencies ==="
sudo apt update
sudo apt install -y \
  meson ninja-build git build-essential pkg-config \
  libpango1.0-dev libcairo2-dev libglib2.0-dev \
  libgdk-pixbuf-2.0-dev libstartup-notification0-dev \
  libxkbcommon-dev libxkbcommon-x11-dev \
  libxcb1-dev libxcb-xkb-dev libxcb-randr0-dev \
  libxcb-xinerama0-dev libxcb-util-dev \
  libxcb-ewmh-dev libxcb-icccm4-dev libxcb-cursor-dev \
  librsvg2-dev libwayland-dev wayland-protocols
sudo apt install libxcb-keysyms1-dev
sudo apt install -y \
  meson ninja-build git build-essential pkg-config \
  libpango1.0-dev libcairo2-dev libglib2.0-dev \
  libgdk-pixbuf-2.0-dev libstartup-notification0-dev \
  libxkbcommon-dev libxkbcommon-x11-dev \
  libxcb1-dev libxcb-xkb-dev libxcb-randr0-dev \
  libxcb-xinerama0-dev libxcb-util-dev \
  libxcb-ewmh-dev libxcb-icccm4-dev libxcb-cursor-dev \
  librsvg2-dev libwayland-dev wayland-protocols \
  libxcb-keysyms1-dev

echo "=== Creating temp directory ==="
TMPDIR=$(mktemp -d)
echo "Temp dir: $TMPDIR"
cd "$TMPDIR"

echo "=== Cloning rofi (lbonn wayland fork) ==="
git clone --depth=1 https://github.com/lbonn/rofi.git
cd rofi

echo "=== Meson setup ==="
meson setup build

echo "=== Building ==="
ninja -C build

echo "=== Installing ==="
sudo ninja -C build install

echo "=== Cleaning up ==="
cd ~
rm -rf "$TMPDIR"

echo "=== DONE ==="
echo "Rofi Wayland build installed successfully."

read -rp "Press ENTER to exit..."
