-- BORDER ANIMATIONS - continuous_rotate preset
hl.config({ animations = { enabled = true } })
hl.curve("myCustomCurve", { type = "bezier", points = { {0.0001, 0.7}, {0.1, 1.0} } })
hl.animation({ leaf = "borderangle", enabled = true, speed = 10, bezier = "myCustomCurve", style = "once" })
