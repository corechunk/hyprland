#!/usr/bin/env bash

LIVE_BASE="$HOME/.config/hypr-lua/configs/animations"
PROJ_BASE="/run/media/part1/inv/codx/remote/bash/dota/hyprland/hypr/configs/animations"

# Fetch available animation themes by looking at the windows directory 
# (Assuming themes are mirrored across all directories)
options=($(find "$LIVE_BASE/windows" -maxdepth 1 -name "*.conf" -not -name "current_windows.conf" -exec basename {} \; | sort))

if [ ${#options[@]} -eq 0 ]; then
    echo "No global animation themes found."
    exit 1
fi

echo "==============================="
echo " Available GLOBAL Themes"
echo " (Applies to Window+Workspace+Layer+Border)"
echo "==============================="
for i in "${!options[@]}"; do
    echo "$((i+1)). ${options[$i]}"
done
echo "==============================="

read -p "Select a number (1-${#options[@]}): " choice

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
    selected_file="${options[$((choice-1))]}"
    
    # Update live and project configs for all three categories
    for category in windows workspaces layers borders; do
        symlink_name="current_${category}.conf"
        
        if [ -f "$LIVE_BASE/$category/$selected_file" ]; then
            ln -sf "$LIVE_BASE/$category/$selected_file" "$LIVE_BASE/$category/$symlink_name"
        fi
    done
    
    echo "Global theme successfully set to: $selected_file"
    hyprctl reload >/dev/null 2>&1
else
    echo "Invalid selection."
    exit 1
fi
