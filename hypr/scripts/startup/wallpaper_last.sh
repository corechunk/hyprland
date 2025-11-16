wp="$(cat "$HOME/.config/hypr/scripts/wallpaper/lastsave.txt")"

# Wait until hyprpaper is running
while ! pgrep -x "hyprpaper" >/dev/null; do
    sleep 0.1
done

# Wait a bit so hyprpaper is ready
sleep 0.3

# Preload first (required before setting wallpaper)
hyprctl hyprpaper preload "$wp"

# Apply to all monitors
hyprctl hyprpaper wallpaper ",$wp"