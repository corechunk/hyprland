-- Hyprland Startup Configuration (hyprland.lua)

hl.on("hyprland.start", function()
    -- Kill lingering pypr instances and launch the daemon with a safe delay
    hl.exec_cmd("killall -q pypr; sleep 0.5; bash -c 'sleep 1 && pypr'")

    -- Core UI components & status bars
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")

    -- System tray & notification daemons
    hl.exec_cmd("nm-applet --indicator")

    -- Clipboard management (cliphist & wl-paste)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Custom user scripts and utilities
    hl.exec_cmd("~/.config/hypr/scripts/dock.sh")
    hl.exec_cmd("~/.config/hypr/scripts/screenshots.sh")
end)
