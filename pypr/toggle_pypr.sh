#!/usr/bin/env bash

# Helper script to toggle pypr scratchpads on-demand.

# Activate mise / asdf / standard user PATHs for non-interactive execution
if command -v mise >/dev/null 2>&1; then
    eval "$(mise env)"
elif [ -x "$HOME/.local/bin/mise" ]; then
    eval "$("$HOME/.local/bin/mise" env)"
fi

export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"

TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <scratchpad_name>"
    exit 1
fi

if [ -f "$HOME/.config/hypr/disable_pypr" ]; then
    exit 0
fi
if [ "$TARGET" = "kill_all" ]; then
    for addr in $(hyprctl clients -j | jq -r '.[] | select(.class | startswith("pypr-term-")) | .address'); do
        hyprctl dispatch closewindow "address:$addr"
    done
    exit 0
fi

# Locate pypr binary dynamically
PYPR_BIN=$(command -v pypr 2>/dev/null)

if [ -z "$PYPR_BIN" ]; then
    for cand in "$HOME/.local/bin/pypr" "$HOME/.local/share/mise/shims/pypr" "/usr/bin/pypr" "/usr/local/bin/pypr"; do
        if [ -x "$cand" ]; then
            PYPR_BIN="$cand"
            break
        fi
    done
fi

if [ -z "$PYPR_BIN" ] || [ ! -x "$PYPR_BIN" ]; then
    exit 1
fi

# Ensure pypr daemon is running
if ! pgrep -x pypr > /dev/null; then
    "$PYPR_BIN" >/dev/null 2>&1 &
    sleep 0.8
fi

"$PYPR_BIN" toggle "$TARGET"
