-- INPUT & DEVICES
-- Configuration for keyboards, pointers, touchpads, and cursor settings

hl.config({
    input = {
        numlock_by_default = true,
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
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
