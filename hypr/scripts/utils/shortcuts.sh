#!/bin/bash
# /* ---- 💫 https://github.com/corechunk 💫 ---- */  ##

# GDK BACKEND. Change to either wayland or x11 if having issues
BACKEND=wayland

# Check if rofi or yad is running and kill them if they are
if pidof rofi > /dev/null; then
  pkill rofi
fi

if pidof yad > /dev/null; then
  pkill yad
fi

# Launch yad with calculated width and height
GDK_BACKEND=$BACKEND yad \
    --center \
    --title="KooL Quick Cheat Sheet" \
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
"SUPER + H" "Show this cheat sheet" "(yad)" \
"SUPER + D" "Application menu" "(rofi)" \
"SUPER + RETURN" "Open terminal" "(kitty)" \
"SUPER + Q" "Close active window" "(killactive)" \
"SUPER + M" "Exit Hyprland" "(exit)" \
"" "" "" \
"___ Applications ___" "" "" \
"SUPER + B" "Open browser" "(firefox)" \
"SUPER + E" "Open file manager" "(thunar)" \
"SUPER + ALT + E" "Open terminal file manager" "(ranger)" \
"" "" "" \
"___ Other ___" "" "" \
"SUPER + W" "Select wallpaper" "(swww)" \
"SUPER + N" "Toggle notifications" "(swaync)" \
"SUPER + ALT + V" "Clipboard history" "(cliphist)" \
"" "" "" \
"___ Window Management ___" "" "" \
"SUPER + Arrows" "Move focus" "" \
"SUPER + SHIFT + Arrows" "Resize window" "" \
"SUPER + CTRL + Arrows" "Move window" "" \
"SUPER + ALT + Arrows" "Swap with other window" "" \
"ALT + Tab" "Cycle to next window" "" \
"SUPER + SPACE" "Toggle floating for one window" "" \
"SUPER + ALT + SPACE" "Toggle floating for all windows" "" \
"SUPER + SHIFT + F" "Toggle fullscreen" "" \
"SUPER + CTRL + F" "Toggle fake fullscreen" "" \
"SUPER + V" "Toggle split layout" "(dwindle)" \
"SUPER + LMB (hold)" "Move window" "" \
"SUPER + RMB (hold)" "Resize window" "" \
"SUPER + MMB" "Toggle floating" "" \
"" "" "" \
"___ Workspace Management ___" "" "" \
"SUPER + 1-9,0" "Switch to workspace 1-10" "" \
"SUPER + SHIFT + 1-9,0" "Move window to workspace 1-10" "" \
"SUPER + CTRL + 1-9,0" "Move window to workspace silently 1-10" "" \
"SUPER + Mouse Wheel" "Cycle through workspaces" "" \
"SUPER + Tab" "Cycle to next workspace" "" \
"SUPER + SHIFT + Tab" "Cycle to previous workspace" "" \
"SUPER + SHIFT + [" "Move window to previous workspace" "" \
"SUPER + SHIFT + ]" "Move window to next workspace" "" \
"SUPER + CTRL + [" "Move window to previous workspace silently" "" \
"SUPER + CTRL + ]" "Move window to next workspace silently" "" \
"______________" "" "" \
"SUPER + U" "Toggle special workspace (scratchpad)" "" \
"SUPER + SHIFT + U" "Move window to special workspace" "" \
"" "" "" \
"___ Screenshots ___" "" "" \
"SUPER + Print" "Take a screenshot" "(grim)" \
"SUPER + SHIFT + Print" "Take a screenshot of a region" "(grim + slurp)" \
"SUPER + CTRL + Print" "Take a screenshot (clipboard only)" "(grim)" \
"SUPER + CTRL + SHIFT + Print" "Take a screenshot of a region (clipboard only)" "(grim + slurp)" \
"" "" "" \
"___ Hyprland Settings ___" "" "" \
"SUPER + R" "Reload Hyprland" "(hyprctl)" \
"SUPER + P" "Toggle pseudo layout" "(dwindle)" \
"" "" "" \
"More tips:" "https://github.com/corechunk/hyprland" ""\