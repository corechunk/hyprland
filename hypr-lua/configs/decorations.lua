-- LOOK AND FEEL & DECORATIONS
-- Settings for borders, opacity, rounding, shadows, and blurs

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 6,
        border_size = 3,
        ["col.active_border"] = { colors = {"rgba(00f5d4ff)", "rgba(00000000)", "rgba(ffffffff)", "rgba(00000000)"}, angle = 45 },
        ["col.inactive_border"] = "rgba(595959aa)",
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 15,
        active_opacity = 0.9,
        inactive_opacity = 0.7,
        shadow = {
            enabled = true,
            range = 3,
            render_power = 1,
            color = "rgba(1a1a1aff)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 2,
            vibrancy = 0.001,
        }
    }
})
