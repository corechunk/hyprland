#!/usr/bin/env bash
# /* ---- 💫 https://github.com/corechunk 💫 ---- */  ##

# GDK BACKEND. Change to either wayland or x11 if having issues
BACKEND=wayland

# Check if rofi or yad is running and kill them if they are
if pidof rofi >/dev/null; then
  pkill rofi #&& exit 0
fi

if pidof yad >/dev/null; then
  pkill yad && exit 0
fi

# Launch yad with calculated width and height
GDK_BACKEND=$BACKEND yad \
    --center \
    --title="corechunk/hyprland keybindings Hint" \
    --width=1000 \
    --height=850 \
    --no-buttons \
    --list \
    --column=Key: \
    --column=Description: \
    --column=Command: \
    --timeout-indicator=bottom \
"ESC" "Close this app" "" \
" = " "SUPER KEY (Windows Key Button)" "(SUPER KEY)" \
"" "" "" \
"___ General ___" "" "" \
"SUPER + H" "Show this cheat sheet [yad]" "bash ~/hypr/scripts/utils/shortcuts.sh" \
"SUPER + D" "Application menu [rofi]" "rofi" \
"SUPER ALT + D" "Nwg-drawer" "nwg-drawer" \
"SUPER + RETURN" "Open terminal [kitty]" "kitty" \
"SUPER + Q" "Close active window" "killactive," \
"SUPER CTRL SHIFT ALT + BACKSPACE" "Exit Hyprland" "exit," \
"SUPER + Z" "Dock utility" "bash ~/hypr/scripts/utils/dock.sh" \
"SUPER SHIFT + B" "Toggle waybar" "pkill -USR1 waybar" \
"SUPER + N" "Toggle notifications [swaync]" "swaync-client -t" \
"SUPER + W" "Select wallpaper [hyprpaper][rofi]" "bash ~/hypr/scripts/wallpaper/wallpaper-select-patch.sh" \
"SUPER ALT + V" "Clipboard history [cliphist][rofi]" "cliphist list | rofi -dmenu | cliphist decode | wl-copy" \
"SUPER + L" "Lock screen [hyprlock]" "hyprlock" \
"SUPER SHIFT + P" "Logout menu" "bash ~/hypr/scripts/utils/logout_menu.sh" \
"" "" "" \
"___ Applications ___" "" "" \
"SUPER + B" "Open browser [firefox]" "firefox" \
"SUPER + E" "Open file manager [thunar]" "thunar" \
"SUPER ALT + E" "Open terminal file manager [kitty][ranger]" "kitty ranger" \
"" "" "" \
"" "" "" \
"___ Window Management ___" "" "" \
"SUPER + Left/Right/Up/Down" "Move focus" "movefocus, <direction>" \
"SUPER SHIFT + Left/Right/Up/Down" "Resize window" "resizeactive, <values>" \
"SUPER CTRL + Left/Right/Up/Down" "Move window" "movewindow, <direction>" \
"SUPER ALT + Left/Right/Up/Down" "Swap with other window" "swapwindow, <direction>" \
"ALT + Tab" "Cycle to next window / Bring to top" "cyclenext / bringactivetotop" \
"SUPER + LMB (hold)" "Move window" "movewindow" \
"SUPER + RMB (hold)" "Resize window" "resizewindow" \
"SUPER + MMB" "Toggle floating" "togglefloating" \
"SUPER SHIFT + F" "Toggle whole fullscreen" "fullscreen" \
"SUPER CTRL + F" "Toggle fake fullscreen" "fullscreen, 1" \
"SUPER + P" "Toggle pseudo layout [dwindle]" "pseudo," \
"SUPER + V" "Toggle split layout [dwindle]" "togglesplit," \
"SUPER + SPACE" "Toggle floating for one window" "togglefloating," \
"SUPER ALT + SPACE" "Toggle all floating windows" "hyprctl dispatch workspaceopt allfloat" \
"" "" "" \
"___ Workspace Management ___" "" "" \
"SUPER + 1-9,0" "Switch to workspace" "workspace, <num>" \
"SUPER SHIFT + 1-9,0" "Move window to workspace" "movetoworkspace, <num>" \
"SUPER CTRL + 1-9,0" "Move window to workspace silently" "movetoworkspacesilent, <num>" \
"SUPER + Mouse Wheel Up/Down" "Cycle through workspaces" "workspace, e+/-1" \
"SUPER + Tab" "Cycle to next workspace" "workspace, e+1" \
"SUPER SHIFT + Tab" "Cycle to previous workspace" "workspace, e-1" \
"SUPER SHIFT + [" "Move window to previous workspace" "movetoworkspace, -1" \
"SUPER SHIFT + ]" "Move window to next workspace" "movetoworkspace, +1" \
"SUPER CTRL + [" "Move window to previous workspace silently" "movetoworkspacesilent, -1" \
"SUPER CTRL + ]" "Move window to next workspace silently" "movetoworkspacesilent, +1" \
"" "" "" \
"___ Special Workspace (Scratchpad) ___" "" "" \
"SUPER + U" "Toggle special workspace (scratchpad)" "togglespecialworkspace, magic" \
"SUPER SHIFT + U" "Move window to special workspace" "movetoworkspace, special:magic" \
"" "" "" \
"___ Screenshots ___" "" "" \
"SUPER + Print" "Take a screenshot [grim]" "bash ~/hypr/scripts/screenshot/screenshot.sh" \
"SUPER SHIFT + Print" "Take a screenshot of a region [grim][slurp]" "bash ~/hypr/scripts/screenshot/screenshot_region.sh" \
"SUPER CTRL + Print" "Take a screenshot [grim] (clipboard only)" "bash ~/hypr/scripts/screenshot/screenshot_clip_only.sh" \
"SUPER CTRL SHIFT + Print" "Take a screenshot of a region [grim][slurp] (clipboard only)" "bash ~/hypr/scripts/screenshot/screenshot_region_clip_only.sh" \
"" "" "" \
"___ Hyprland Settings ___" "" "" \
"SUPER + R" "Reload Hyprland [hyprctl]" "hyprctl reload" \
"SUPER + P" "Toggle pseudo layout [dwindle]" "pseudo," \
"" "" "" \
"More tips:" "https://github.com/corechunk/hyprland" ""\