#!/usr/bin/env bash

LIVE_DIR="$HOME/.config/hypr/configs/animations/borders"
PROJ_DIR="/run/media/part1/inv/codx/remote/bash/dota/hyprland/hypr/configs/animations/borders"

# Fetch available border configs, excluding the symlink itself
options=($(find "$LIVE_DIR" -maxdepth 1 -name "*.conf" -not -name "current_borders.conf" -exec basename {} \; | sort))

if [ ${#options[@]} -eq 0 ]; then
    echo "No border animation presets found in $LIVE_DIR"
    exit 1
fi

echo "==========================="
echo " Available Border Presets"
echo "==========================="
for i in "${!options[@]}"; do
    echo "$((i+1)). ${options[$i]}"
done
echo "==========================="

read -p "Select a number (1-${#options[@]}): " choice

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
    selected_file="${options[$((choice-1))]}"
    
    # Update live config symlink
    ln -sf "$LIVE_DIR/$selected_file" "$LIVE_DIR/current_borders.conf"
    
    echo "Border animation successfully set to: $selected_file"
    hyprctl reload >/dev/null 2>&1
else
    echo "Invalid selection."
    exit 1
fi
