#!/bin/bash
# Patched Rofi Wallpaper Chooser with Preview (Wayland)
# Works with lbonn's Rofi patch (Wayland + element icons)

# -----------------------------
# CONFIG
# -----------------------------
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
LASTSAVE="$HOME/.config/hypr/scripts/wallpaper/lastsave.txt"

# -----------------------------
# COLLECT WALLPAPERS
# -----------------------------
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" \) | sort)

[ ${#wallpapers[@]} -eq 0 ] && { echo "No wallpapers found"; exit 1; }

# Extract filenames only
filenames=()
for wp in "${wallpapers[@]}"; do
    filenames+=("$(basename "$wp")")
done

# -----------------------------
# CALCULATE ICON SIZE
# -----------------------------
focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
scale_factor=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .scale')
monitor_height=$(hyprctl monitors -j | jq -r --arg mon "$focused_monitor" '.[] | select(.name == $mon) | .height')

# Fallback if bc is missing
if ! command -v bc &>/dev/null; then
    adjusted_icon_size=20
else
    icon_size=$(echo "scale=1; ($monitor_height * 3) / ($scale_factor * 150)" | bc)
    adjusted_icon_size=$(echo "$icon_size" | awk '{if ($1 < 15) $1 = 20; if ($1 > 25) $1 = 25; print $1}')
fi

# -----------------------------
# FUNCTION TO GENERATE OPTIONS
# -----------------------------
opts() {
    for i in "${!filenames[@]}"; do
        # Rofi requires: label \x00icon\x1f path
        printf "%s\x00icon\x1f%s\n" "${filenames[$i]}" "${wallpapers[$i]}"
    done
}

# -----------------------------
# SHOW ROFI MENU
# -----------------------------
chosen=$(opts | rofi -i -dmenu \
                    -theme-str "element-icon{size:${adjusted_icon_size}%;}" \
                    -p "Choose wallpaper:")

[ -z "$chosen" ] && exit 0

# -----------------------------
# MAP FILENAME TO FULL PATH
# -----------------------------
fullpath=""
for wp in "${wallpapers[@]}"; do
    [ "$(basename "$wp")" = "$chosen" ] && fullpath="$wp" && break
done

[ -z "$fullpath" ] && { echo "Failed to find wallpaper"; exit 1; }

# -----------------------------
# SET WALLPAPER VIA HYPRPAPER
# -----------------------------
killall hyprpaper 2>/dev/null
hyprpaper &
sleep 0.2 # wait for hyprpaper to start

hyprctl hyprpaper preload "$fullpath"
hyprctl hyprpaper wallpaper ",$fullpath"

# -----------------------------
# SAVE LAST CHOSEN WALLPAPER
# -----------------------------
mkdir -p "$(dirname "$LASTSAVE")"
echo "$fullpath" > "$LASTSAVE"
