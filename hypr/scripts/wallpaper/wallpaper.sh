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

rofi_theme="$HOME/.config/rofi/config-wallpaper.rasi" 
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale') 
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height') 
icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc) 
adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}') 
rofi_override="element-icon{size:${adjusted_icon_size}%;}" 

# Let user choose with rofi
chosen=$(printf '%s\n' "${filenames[@]}" | rofi -i -show -dmenu -config $rofi_theme -theme-str $rofi_override -p "Choose wallpaper:")
#chosen=$(printf '%s\n' "${filenames[@]}" | rofi -i -show -dmenu -config $rofi_theme -p "Choose wallpaper:")
#chosen=$(printf '%s\n' "${filenames[@]}" | rofi -i -show -dmenu -p "Choose wallpaper:")

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

rm                 $HOME/.config/hypr/scripts/wallpaper/lastsave.txt
echo "$fullpath" > $HOME/.config/hypr/scripts/wallpaper/lastsave.txt