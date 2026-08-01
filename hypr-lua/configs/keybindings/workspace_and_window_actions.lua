-- WORKSPACE & WINDOW ACTIONS
-- Keybindings for managing window layouts, workspace navigation, and monitor settings

local mainMod = "SUPER"

-- Windows: Move focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Windows: Resize current active window (repeating keybinds)
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

-- Windows: Move position
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.move({ direction = "d" }))

-- Windows: Swap position with another window
hl.bind(mainMod .. " + ALT + left", function() hl.dispatch("swapwindow", "l") end)
hl.bind(mainMod .. " + ALT + right", function() hl.dispatch("swapwindow", "r") end)
hl.bind(mainMod .. " + ALT + up", function() hl.dispatch("swapwindow", "u") end)
hl.bind(mainMod .. " + ALT + down", function() hl.dispatch("swapwindow", "d") end)

-- Windows: Cycle windows and bring to top on Alt+Tab
hl.bind("ALT + TAB", function()
    hl.dispatch("cyclenext")
    hl.dispatch("bringactivetotop")
end)

-- Switch workspaces with mainMod + [0-9]
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
end
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window and follow to workspace mainMod + SHIFT [0-9]
-- (Using key codes to avoid layout issues)
local workspaceCodes = {
    [10] = "1", [11] = "2", [12] = "3", [13] = "4", [14] = "5",
    [15] = "6", [16] = "7", [17] = "8", [18] = "9", [19] = "10"
}
for code, ws in pairs(workspaceCodes) do
    hl.bind(mainMod .. " + SHIFT + code:" .. code, function() hl.dispatch("movetoworkspace", ws) end)
    hl.bind(mainMod .. " + CTRL + code:" .. code, function() hl.dispatch("movetoworkspacesilent", ws) end)
end

hl.bind(mainMod .. " + SHIFT + bracketleft", function() hl.dispatch("movetoworkspace", "-1") end)
hl.bind(mainMod .. " + SHIFT + bracketright", function() hl.dispatch("movetoworkspace", "+1") end)
hl.bind(mainMod .. " + CTRL + bracketleft", function() hl.dispatch("movetoworkspacesilent", "-1") end)
hl.bind(mainMod .. " + CTRL + bracketright", function() hl.dispatch("movetoworkspacesilent", "+1") end)

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + U", function() hl.dispatch("movetoworkspace", "special:magic") end)

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", function() hl.dispatch("workspace", "e+1") end)
hl.bind(mainMod .. " + mouse_up", function() hl.dispatch("workspace", "e-1") end)
hl.bind(mainMod .. " + TAB", function() hl.dispatch("workspace", "e+1") end)
hl.bind(mainMod .. " + SHIFT + TAB", function() hl.dispatch("workspace", "e-1") end)

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
