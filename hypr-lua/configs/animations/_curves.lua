-- BEZIER CURVES
-- Curve definitions to be used by animations

-- Default curves
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

-- New Preset Curves
hl.curve("snappy", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("bouncy", { type = "bezier", points = { {0.175, 0.885}, {0.32, 1.275} } })
hl.curve("smooth", { type = "bezier", points = { {0.4, 0}, {0.2, 1} } })
