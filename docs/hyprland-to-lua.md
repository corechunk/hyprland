# Hyprland legacy configuration to Lua Translation Reference

This document covers the rules, patterns, and mapping strategies used when translating legacy Hyprland configs (`hyprlang` syntax) into the modern Lua-based API (`hyprland.lua` format) supported by Hyprland v0.55+.

---

## 1. Directory Structure & Imports

### Legacy `.conf` Sourcing
In the legacy format, configs are imported using absolute or relative file path strings:
```ini
source = $configs_DIR/decorations.conf
```

### Lua Module Loading
In Lua, configuration files are loaded as modules. We set the package paths at the top of `hyprland.lua` and then load them using `require()`:
```lua
local home = os.getenv("HOME")
package.path = package.path .. ";" .. home .. "/.config/hypr-lua/?.lua;" .. home .. "/.config/hypr-lua/?/init.lua"

require("configs.decorations")
```

---

## 2. Variables & Constants

### Legacy variables
Prefix variables with `$`:
```ini
$terminal = kitty
```

### Lua variables
Define variables globally (without the `local` keyword) so that they are accessible by any module required after them:
```lua
terminal = "kitty"
```

---

## 3. Autostart & Reload Execs

### Legacy Execution
```ini
exec-once = waybar
exec = script.sh
```

### Lua Execution Hooks
Exec-once commands (run only on initial launch) should be passed into a global `hl.config` block using array format. Any command that needs to execute on configuration reloads can be configured in a similar array via `exec`:
```lua
hl.config({
    ["exec-once"] = {
        "waybar",
        "pypr",
    },
    exec = {
        "script.sh"
    }
})
```

---

## 4. Environment Variables

### Legacy Env Setting
```ini
env = XCURSOR_SIZE,24
```

### Lua Env Setting
```lua
hl.env("XCURSOR_SIZE", "24")
```

---

## 5. Composition Configurations (decorations, layouts, inputs, etc.)

### Legacy Formats
```ini
general {
    gaps_in = 3
    col.active_border = rgba(00f5d4ff)
}
```

### Lua Table Configurations
Configurations are passed to `hl.config()` as nested key-value tables. Keys containing dots (`col.active_border`) must be written as string keys using square brackets.

**Important for Colors:** Hex strings must be 6 or 8 digits (e.g. `rgba(ffffffff)` instead of `rgba(ffffff)`). Additionally, gradients should be structured as tables with a `colors` array and an `angle`:
```lua
hl.config({
    general = {
        gaps_in = 3,
        ["col.active_border"] = { colors = {"rgba(00f5d4ff)", "rgba(ffffffff)"}, angle = 45 },
    }
})
```

---

## 6. Monitors & Workspaces

### Legacy Displays & Workspaces
```ini
monitor=eDP-1,1920x1080@59.98,0x0,1.25
workspace=1,monitor:eDP-1
```

### Lua Displays & Workspaces
Monitors are configured using `hl.monitor()`, and workspace monitor assignments are defined using `hl.workspace_rule()`:
```lua
hl.monitor({
    output = "eDP-1",
    mode = "1920x1080@59.98",
    position = "0x0",
    scale = 1.25
})

hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
```

---

## 7. Window & Layer Rules

### Legacy Window & Layer Rules
Legacy uses comma-separated flags, properties, and regex matching strings:
```ini
windowrulev2 = float, class:^(kitty)$
windowrulev2 = size 800 600, class:^(kitty)$, title:^(update)$

layerrule = blur, waybar
layerrule = ignorealpha 0.2, waybar
```

### Lua Window & Layer Rules
In Lua, rules are passed as tables to `hl.window_rule()` and `hl.layer_rule()`. The matching criteria (class, title, namespace) goes into a nested `match` table:
```lua
-- Window Rules
hl.window_rule({ match = { class = "^(kitty)$" }, float = true })
hl.window_rule({ match = { class = "^(kitty)$", title = "^(update)$" }, size = "800 600" })

-- Layer Rules
hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "waybar" }, ignorealpha = "0.2" })
```

---

## 8. Animations & Bezier Curves

### Legacy Animations
```ini
bezier = smooth, 0.4, 0.0, 0.2, 1.0
animation = windows, 1, 4.79, smooth
```

### Lua Curves & Animations
Bezier curves must be defined using `hl.curve()` before they can be assigned via `hl.animation()`:
```lua
hl.curve("smooth", { type = "bezier", points = { {0.4, 0}, {0.2, 1} } })

hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "smooth" })
```

---

## 9. Touchpad Gestures

### Legacy Gestures
```ini
gestures {
    gesture = 3, left, dispatcher, workspace, m+1
}
```

### Lua Gestures
The `hl.gesture` table in Lua currently only natively maps basic actions with valid internal orientations (e.g., `horizontal` or `vertical`). Swiping left/right to move workspaces is handled natively by the `"workspace"` action:
```lua
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
```

**Advanced Gestures:** Custom dispatchers via gestures (e.g., running `exec` commands) are extremely strict within the `hl.gesture` table and often throw `unknown action`. Instead, map them using explicit internal bindings:
```lua
hl.bind("swipe:4:d", hl.dsp.exec_cmd("bash script.sh"))
hl.bind("swipe:3:u", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
```

---

## 10. Keybindings

### Legacy Keybind Commands
Legacy keybindings map mod keys, shortcuts, dispatchers, and arguments directly:
```ini
bind = SUPER, Q, killactive,
binde = SUPER, left, resizeactive, -20 0
bindm = SUPER, mouse:272, movewindow
```

### Lua Keybindings
Mapped using `hl.bind()`. Modifier flags (like repeating or mouse binding) are passed in the third argument as a options table:
```lua
-- Standard Keybind
hl.bind("SUPER + Q", hl.dsp.window.close())

-- Repeating Keybind (binde)
hl.bind("SUPER + SHIFT + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })

-- Mouse Binding (bindm)
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
```

### Fallback/Raw Dispatching & Dispatcher Objects
In the Hyprland Lua API, `hl.dispatch()` and `hl.bind()` expect **dispatcher objects** created via the `hl.dsp` namespace (e.g. `hl.dsp.window.move({ workspace = ws })` or `hl.dsp.window.swap({ direction = "left" })`).

**Do NOT pass string command names directly to `hl.dispatch("movetoworkspace", "1")`** — doing so will trigger a runtime error: `hl.dispatch: expected a dispatcher (e.g. hl.dsp.window.close())`.

For commands without direct structured `hl.dsp` helpers, wrap the string command in `hl.dsp.exec_cmd("hyprctl dispatch ...")`:
-- Structured dispatcher objects (Recommended)
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind("SUPER + CTRL + 1", hl.dsp.window.move({ workspace = "1", follow = false }))
hl.bind("SUPER + ALT + left", hl.dsp.window.swap({ direction = "left" }))

-- Raw hyprctl fallback for custom commands
hl.bind("SUPER + ALT + K", hl.dsp.exec_cmd("bash script.sh kill_all"))
```

---

## 11. Debugging & Fallback Behavior

### Autogenerated Config Warnings
If you encounter a yellow bar at the top of your screen stating **"Warning: You're using an autogenerated config!"**, it usually means one of two things:
1. Your Lua configuration encountered a syntax or runtime error during evaluation.
2. An API method was called with invalid arguments (e.g. an invalid gesture action or a missing bezier curve).

**Hyprland's Fallback Mechanism:**
When Hyprland v0.55+ encounters a fatal error while loading `hyprland.lua`, it abruptly stops evaluating the Lua script and automatically generates a fresh `hyprland.conf` file in the same directory as a fallback. 
Because Hyprland prioritizes `.conf` files over `.lua` files on startup, it will continue loading this autogenerated config on all subsequent reloads until you manually delete it.

### The Golden Rule of Lua Migration: Reloading vs. Restarting
When migrating from legacy `.conf` to `.lua`, simply replacing the files in your `~/.config/hypr` directory and running `hyprctl reload` **will not work directly**.

* **Hyprland locks the configuration format on launch.** If you booted your session using a legacy `.conf` file, `hyprctl reload` will only ever look for and evaluate `.conf` files. It will completely ignore `hyprland.lua` regardless of what you do.
* **To initially switch to Lua (or switch back), you must completely exit Hyprland.** Use your logout keybind (e.g., `SUPER + M`) or run `hyprctl dispatch exit` to kill the session, then log back in from your display manager or TTY.
* If you hit a Lua crash and the system autogenerates a fallback `.conf`, you are instantly trapped back in `.conf` mode. You must delete the fallback `.conf` file and perform a full `dispatch exit` and restart to return to testing your Lua scripts.
