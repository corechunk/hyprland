-- INPUT & DEVICES
-- Configuration for keyboards, pointers, touchpads, and cursor settings

hl.config({
    input = {
        numlock_by_default = true,
        kb_layout = "us,ara,bd", -- def: us
        kb_variant = ",buckwalter,probhat", -- def:
        kb_options = "grp:alt_shift_toggle", -- def: ""
            -- "caps:swapescape" for swapping tab and esc key with each other
            -- "grp:alt_shift_toggle" for switching language with 'alt + shift'
        kb_model = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        }
    },
    cursor = {
        no_hardware_cursors = true,
    }
})

-- Per-device configurations
hl.device({
    name = "epic-mouse-v1",
    sensitivity = -0.5,
})
