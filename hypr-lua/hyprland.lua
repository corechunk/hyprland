-- Main Hyprland configuration (Lua port)
-- Documentation: https://wiki.hypr.land/Configuring/Start/

local home = os.getenv("HOME")
-- Paths point to ~/.config/hypr — the live install location (rsync target from dev.sh option 2)
package.path = package.path .. ";" .. home .. "/.config/hypr/?.lua;" .. home .. "/.config/hypr/?/init.lua"

-- Global directory variables for shell scripts and resources
hypr_DIR = home .. "/.config/hypr"
configs_DIR = hypr_DIR .. "/configs"
keybindings_DIR = configs_DIR .. "/keybindings"
scripts_DIR = hypr_DIR .. "/scripts"
QS_DIR = home .. "/.config/quickshell"

-- Load helper modules and layouts
require("configs.variables")
require("configs.colors.current_color")
require("configs.startups")
require("configs.monitors")
require("configs.environment")
require("configs.decorations")

-- Animations loading
require("configs.animations._curves")
require("configs.animations.windows.current_windows")
require("configs.animations.workspaces.current_workspaces")
require("configs.animations.layers.current_layers")
require("configs.animations.borders.current_borders")

require("configs.layouts")
require("configs.inputs")
require("configs.gestures")
require("configs.keybindings")
require("configs.windowrules")

-- Compositor settings
hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },
    xwayland = {
        force_zero_scaling = true,
    }
})

-- Reload shortcut
hl.bind("SUPER + R", hl.dsp.exec_cmd("hyprctl reload"))
