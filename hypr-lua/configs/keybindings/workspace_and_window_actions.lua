-- WORKSPACE & WINDOW ACTIONS
-- Keybindings for managing window layouts, workspace navigation, and monitor settings

local mainMod = "SUPER"

-- Windows: Move focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Windows: Resize current active window (repeating keybinds)
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

-- Windows: Move position
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "down" }))

-- Windows: Swap position with another window
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.swap({ direction = "down" }))

-- Windows: Cycle windows and bring to top on Alt+Tab
hl.bind("ALT + TAB", hl.dsp.exec_cmd("hyprctl dispatch cyclenext && hyprctl dispatch bringactivetotop"))

-- Switch workspaces with mainMod + [0-9]
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to workspace (mainMod + SHIFT + [0-9])
-- Move active window SILENTLY to workspace (mainMod + CTRL + [0-9] and mainMod + ALT + [0-9])
for i = 1, 9 do
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
    --hl.bind(mainMod .. " + ALT + " .. i, hl.dsp.window.move({ workspace = i, follow = false }))
end
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))
hl.bind(mainMod .. " + CTRL + 0", hl.dsp.window.move({ workspace = 10, follow = false }))
hl.bind(mainMod .. " + ALT + 0", hl.dsp.window.move({ workspace = 10, follow = false }))

hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1" }))
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1" }))
hl.bind(mainMod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = false }))
hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + TAB", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse bindings (move/resize/float by dragging)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + mouse:274", hl.dsp.window.float({ action = "toggle" }), { mouse = true })

-- HDMI Monitor Control
hl.bind(mainMod .. " + CTRL + SHIFT + ALT + E", hl.dsp.exec_cmd("hyprctl keyword monitor \"HDMI-A-1,1920x1080@60,auto-right,1.0\""))
hl.bind(mainMod .. " + CTRL + SHIFT + ALT + M", hl.dsp.exec_cmd("hyprctl keyword monitor \"HDMI-A-1,1920x1080@60,0x0,1.0,mirror,eDP-1\""))
hl.bind(mainMod .. " + CTRL + SHIFT + ALT + X", hl.dsp.exec_cmd("hyprctl keyword monitor \"HDMI-A-1,disable\""))

hl.bind(mainMod .. " + CTRL + SHIFT + ALT + LEFT", hl.dsp.exec_cmd("hyprctl keyword monitor \"HDMI-A-1,1920x1080@60,auto-left,1.25\""))
hl.bind(mainMod .. " + CTRL + SHIFT + ALT + RIGHT", hl.dsp.exec_cmd("hyprctl keyword monitor \"HDMI-A-1,1920x1080@60,auto-right,1.25\""))
hl.bind(mainMod .. " + CTRL + SHIFT + ALT + UP", hl.dsp.exec_cmd("hyprctl keyword monitor \"HDMI-A-1,1920x1080@60,auto-up,1.25\""))
hl.bind(mainMod .. " + CTRL + SHIFT + ALT + DOWN", hl.dsp.exec_cmd("hyprctl keyword monitor \"HDMI-A-1,1920x1080@60,auto-down,1.25\""))
