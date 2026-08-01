-- ENVIRONMENT VARIABLES
-- System environment variables for Wayland, fonts, and application compatibility

hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_SIZE", "24")

-- Wayland-specific environment variables [fixed app anti aliasing]
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Electron / Ozone platform hint (fixes many Electron apps like Discord/Edge)
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Font rendering (Added for sharpening)
hl.env("XFT_ANTIALIAS", "1")
hl.env("XFT_HINTING", "1")
hl.env("XFT_HINTSTYLE", "hintslight")
hl.env("XFT_RGBA", "rgb")
