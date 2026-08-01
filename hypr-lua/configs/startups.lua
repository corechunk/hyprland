-- AUTOSTART
-- Autostart necessary processes (like notification daemons, status bars, etc.)

hl.config({
    ["exec-once"] = {
        terminal,
        "waybar",
        "hyprpaper -c " .. os.getenv("HOME") .. "/.config/hypr-lua/hyprpaper.conf",
        "nm-applet",
        "bash " .. scripts_DIR .. "/utils/dock.sh",
        "pypr",
        
        -- Clipboard manager startup
        "wl-paste --type text --watch cliphist store",
        "wl-paste --type image --watch cliphist store",
        
        -- Notification daemon startup
        "killall -q dunst mako fnott swaynotificationd notify-osd swaync; sleep 0.2; swaync",
        
        -- Set up screenshot directory
        scripts_DIR .. "/startup/screenshot-dir.sh"
    }
})

-- Execute on every configuration reload
-- hl.config({ exec = { scripts_DIR .. "/startup/wallpaper-last.sh" } })
