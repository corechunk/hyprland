-- TOUCHPAD GESTURES
-- Configuration for swipe and pinch gestures

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Advanced gestures with custom dispatchers are not fully supported natively via hl.gesture in the current Lua API yet.
-- hl.bind("swipe:4:d", hl.dsp.exec_cmd("bash " .. pypr_script .. " term_0"))
-- hl.bind("swipe:4:u", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
-- hl.bind("swipe:4:r", hl.dsp.exec_cmd("wpctl set-volume -l 2 @DEFAULT_AUDIO_SINK@ 10%+"))
-- hl.bind("swipe:4:l", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"))
-- hl.bind("swipe:3:u", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
-- hl.bind("swipe:3:d", hl.dsp.window.float({ action = "toggle" }))

