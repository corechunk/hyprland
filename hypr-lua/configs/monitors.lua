-- MONITORS & WORKSPACES
-- Configuration for displays and workspace assignments

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@59.98",
    position = "0x0",
    scale = 1.25
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "1920x1080@60",
    position = "auto-right",
    scale = 1.0
})

-- Laptop workspaces (1-4 assigned to laptop screen)
hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })

-- HDMI workspaces (5-8 assigned to external screen)
hl.workspace_rule({ workspace = "5", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "6", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "7", monitor = "HDMI-A-1" })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1" })
