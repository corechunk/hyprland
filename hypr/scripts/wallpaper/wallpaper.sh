#!/bin/bash

# Wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Get list of wallpaper files (full path)
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | sort)

# If no wallpapers found
[ ${#wallpapers[@]} -eq 0 ] && exit 1

# Extract filenames only for rofi display
filenames=()
for wp in "${wallpapers[@]}"; do
    filenames+=("$(basename "$wp")")
done

# Let user choose with rofi
chosen=$(printf '%s\n' "${filenames[@]}" | rofi -show-icon -dmenu -p "Choose wallpaper:")

# If user cancels
[ -z "$chosen" ] && exit 0

# Map selected filename back to full path
for wp in "${wallpapers[@]}"; do
    if [ "$(basename "$wp")" = "$chosen" ]; then
        fullpath="$wp"
        break
    fi
done

# Kill existing hyprpaper daemon
killall hyprpaper 2>/dev/null

# Relaunch hyprpaper
hyprpaper &
sleep 0.2 # wait for hyprpaper

# Set wallpaper
hyprctl hyprpaper preload "$fullpath"
hyprctl hyprpaper wallpaper ",$fullpath"
