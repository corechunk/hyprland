-- SCREENSHOT KEYBINDINGS
-- Binds for capturing screenshots using grim/slurp scripts

local mainMod = "SUPER"

hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/screenshot/screenshot.sh"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/screenshot/screenshot_region.sh"))

hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/screenshot/screenshot.sh"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/screenshot/screenshot_region.sh"))

hl.bind(mainMod .. " + CTRL + Print", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/screenshot/screenshot_clip_only.sh"))
hl.bind(mainMod .. " + CTRL + SHIFT + Print", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/screenshot/screenshot_region_clip_only.sh"))

hl.bind(mainMod .. " + CTRL + S", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/screenshot/screenshot_clip_only.sh"))
hl.bind(mainMod .. " + CTRL + SHIFT + S", hl.dsp.exec_cmd("bash " .. scripts_DIR .. "/screenshot/screenshot_region_clip_only.sh"))
