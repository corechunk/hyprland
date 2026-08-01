-- PYPRLAND KEYBINDINGS
-- Keybindings for managing dropdown terminal scratchpads

local mainMod = "SUPER"

-- Alt + Space for index 0 dropdown terminal
hl.bind("ALT + SPACE", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_0"))

-- Win + Alt + [0-9] keybindings for index 0..9 dropdown terminals
hl.bind(mainMod .. " + ALT + 0", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_0"))
hl.bind(mainMod .. " + ALT + 1", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_1"))
hl.bind(mainMod .. " + ALT + 2", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_2"))
hl.bind(mainMod .. " + ALT + 3", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_3"))
hl.bind(mainMod .. " + ALT + 4", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_4"))
hl.bind(mainMod .. " + ALT + 5", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_5"))
hl.bind(mainMod .. " + ALT + 6", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_6"))
hl.bind(mainMod .. " + ALT + 7", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_7"))
hl.bind(mainMod .. " + ALT + 8", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_8"))
hl.bind(mainMod .. " + ALT + 9", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_9"))

-- Win + Alt + K to kill all pyprland dropdown terminals at once
hl.bind(mainMod .. " + ALT + K", hl.dsp.exec_cmd("bash " .. pypr_script .. " kill_all"))
