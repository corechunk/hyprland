# Debian Sid Hyprland Downgrade & Recovery Documentation

This document logs the complete journey of recovering a broken Hyprland ecosystem after an unstable upgrade on Debian Sid (amd64).

---

## 1. The Core Problem
An upgrade in Debian Sid pulled in the newer **Hyprland v0.56.0** package stack. This stack introduced ABI conflicts and dependency restructurings (such as requiring `libhyprutils13` instead of `libhyprutils12`). This caused:
* **Immediate Segfaults** on launch.
* Incompatibility with other running ecosystem packages (like `hyprlock` and `xdg-desktop-portal-hyprland`).

Since Debian Sid is rolling/unstable, old working packages are removed from standard repositories immediately, meaning standard `apt install package=version` fails.

---

## 2. Step 1: Downloading Older Packages
We utilized the machine-readable API of `snapshot.debian.org` to target and fetch the last known working versions of the Hyprland stack. 

* **Directory created:** `/home/netchunk/hypr_debs`
* **Log file generated:** `/home/netchunk/recovery/downgrade_log.txt`
* **Target versions resolved:**
  * `hyprland`: `0.55.4+ds-2+b1`
  * `hyprland-guiutils`: `0.2.1-3+b2`
  * `hyprlock`: `0.9.5-2`
  * `xdg-desktop-portal-hyprland`: `1.3.12-1+b1`
  * `hyprcursor-util`: `0.1.13-2~bpo13+1`
  * `libhyprcursor0`: `0.1.13-2~bpo13+1`

---

## 3. Step 2: The Library Mismatch & Resolving Dependencies
During the initial downgrade script run, we attempted to downgrade all underlying libraries (`libaquamarine11`, `libhyprgraphics4`, `libhyprlang2`, etc.) to match. 

This resulted in:
1. **Broken dependencies:** Downgrading the libraries broke compatibility since the downgraded packages (such as `libhyprgraphics4 0.5.1-2`) expected old packages (like `libhyprutils11`) which no longer exist in Sid.
2. **The Fix:** We ran `sudo apt-get -f install` to let `apt` intelligently upgrade the library packages back to their `+b1`/`+b2` rebuilds, while keeping the main applications (`hyprland`, `hyprlock`, etc.) safely at their downgraded versions.

---

## 4. Step 3: Pinning & Holding Packages
To prevent `apt upgrade` or `apt full-upgrade` from pulling the broken versions back in, we pinned the main ecosystem packages:

```bash
sudo apt-mark hold hyprland hyprland-guiutils hyprlock hyprpaper libaquamarine11 libhyprcursor0 libhyprgraphics4 libhyprlang2 libhyprtoolkit5 libhyprutils-dev libhyprutils12 libhyprutils13 libhyprwire3 xdg-desktop-portal-hyprland
```

---

## 5. Step 4: SDDM vs kmscon VT Conflict
After reboot, SDDM was set to `MinimumVT=1` in `/etc/sddm.conf.d/vt.conf`, but `kmsconvt@tty1.service` was also enabled — both fighting over TTY 1 and the DRM device simultaneously.

This caused `drm: Cannot commit when a page-flip is awaiting` errors in the Hyprland log, making it exit immediately every time SDDM tried to launch it.

**Fix 1 — Move SDDM to start from TTY 2:**
```bash
# Edit /etc/sddm.conf.d/vt.conf
[X11]
MinimumVT=2

[Wayland]
MinimumVT=2
```

**Fix 2 — Disable kmscon on TTY 1 (was wrongly re-enabled by apt full-upgrade):**
```bash
sudo systemctl disable --now kmsconvt@tty1.service
```

**Correct VT layout after fix:**
| TTY | Service |
|---|---|
| TTY 1 | free / plain getty |
| TTY 2 | SDDM X greeter |
| TTY 3 | Hyprland Wayland session |
| TTY 5-8 | kmscon |
| TTY 9-12 | getty |

---

## 6. Step 5: The Custom Shell Watchdog Fix (`/usr/local/bin/hyprland-session`)
While launching `hyprland` manually from a physical TTY console worked, launching it through **SDDM** kept failing.

### The Diagnostic Chain:
1. **Official `/usr/bin/start-hyprland` binary:** This compiled C++ watchdog binary was crashing with `SIGSEGV` (Exit Code 11) under SDDM due to dynamic linking / ABI conflicts with the hybrid downgraded library stack.
2. **Bare `/usr/bin/Hyprland` in `hyprland.desktop`:** When bypassing `start-hyprland` and calling `Hyprland` directly, SDDM failed with Exit Code 1. Hyprland would hit a minor, transient DRM race condition on startup (`drm: Cannot commit when a page-flip is awaiting`) and exit immediately. Without a watchdog process to catch and retry it, SDDM closed the session and dropped back to a TTY.
3. **The Final Solution (`/usr/local/bin/hyprland-session`):** We created a pure Bash watchdog script that replaces `start-hyprland`:
   - Exports all required Wayland desktop environment variables.
   - Runs `/usr/bin/Hyprland`.
   - On exit, checks the exit code. If non-zero (transient startup crash), it automatically retries launching Hyprland up to 3 times with a 1-second delay.
   - On the 2nd attempt, the DRM lock clears cleanly and the desktop loads smoothly!

**Watchdog Script (`/usr/local/bin/hyprland-session`):**
```bash
#!/bin/bash
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP=Hyprland

MAX_RETRIES=3
attempt=0

while [ $attempt -lt $MAX_RETRIES ]; do
    /usr/bin/Hyprland "$@"
    exit_code=$?

    if [ $exit_code -eq 0 ]; then
        echo "Hyprland exited cleanly."
        exit 0
    fi

    attempt=$((attempt + 1))
    echo "Hyprland exited with code $exit_code (attempt $attempt/$MAX_RETRIES), restarting in 1s..."
    sleep 1
done

echo "Hyprland failed after $MAX_RETRIES attempts."
exit 1
```

**Desktop Entry (`/usr/share/wayland-sessions/hyprland.desktop`):**
```ini
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=/usr/local/bin/hyprland-session
Type=Application
DesktopNames=Hyprland
Keywords=tiling;wayland;compositor;
```

---

## 7. How to Restore/Upgrade in the Future
Once the bugs in the upstream `0.56` branch are resolved, you can fully upgrade your system again by releasing the holds:

```bash
# 1. Unhold all packages
sudo apt-mark unhold hyprland hyprland-guiutils hyprlock hyprpaper libaquamarine11 libhyprcursor0 libhyprgraphics4 libhyprlang2 libhyprtoolkit5 libhyprutils-dev libhyprutils12 libhyprutils13 libhyprwire3 xdg-desktop-portal-hyprland

# 2. Restore the desktop entry back to standard start-hyprland wrapper
sudo sed -i 's|Exec=/usr/local/bin/hyprland-session|Exec=/usr/bin/start-hyprland|' /usr/share/wayland-sessions/hyprland.desktop

# 3. Re-enable kmscon on tty1 (optional, if desired)
sudo systemctl enable --now kmsconvt@tty1.service

# 4. Upgrade everything
sudo apt update && sudo apt full-upgrade
```
