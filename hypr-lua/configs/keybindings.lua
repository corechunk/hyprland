-- KEYBINDINGS
-- Basic system keybindings and imports for modular binding files

local mainMod = "SUPER"

-- Basic Actions
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/utils/shortcuts.sh"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + CTRL + SHIFT + ALT + BACKSPACE", hl.dsp.exit())
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/utils/dock.sh"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + ALT + D", hl.dsp.exec_cmd("nwg-drawer"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd("pkill -USR1 waybar"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))

hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/wallpaper/wallpaper-select-patch.sh"))
hl.bind(mainMod .. " + ALT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(QS_DIR .. "/modules/SessionLock/lock.sh"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/utils/logout_menu.sh"))

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("env MOZ_ENABLE_WAYLAND=1 " .. browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd(terminal .. " " .. fileManager_alt))

-- Hyprland window management actions
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind(mainMod .. " + CTRL + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "maximized" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))


-- Quickshell shortcuts
hl.bind(mainMod .. " + ALT + N", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/quickshell/scripts/modules/launch.sh ConnectionManager --fromShortcut"))
hl.bind(mainMod .. " + ALT + A", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/quickshell/scripts/modules/launch.sh MediaControl --fromShortcut"))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/quickshell/scripts/apps/launch.sh CommandPalette"))

-- Import other sub-keybindings
require("configs.keybindings.workspace_and_window_actions")
require("configs.keybindings.screenshot")
require("configs.keybindings.function_binds")
require("configs.keybindings.pypr_keybindings")
