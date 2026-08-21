# Comprehensive Linux TTY, Virtual Terminal (VT), Display Manager & Console Guide

This document is an architectural reference manual covering Linux Kernel VTs, Getty text consoles, GPU/KMS-accelerated consoles (kmscon), Pseudo-Terminals (PTS), Display Managers (SDDM/GDM), and how to configure their passive (startup configs) and active (systemd unit commands) state management.

---

## 1. Core Architectural Concepts

### A. The Kernel TTY & Virtual Terminals (VTs)
- **What it is:** The Linux kernel includes a built-in terminal subsystem (`/dev/tty1` to `/dev/tty63`). These are low-level kernel abstractions linked to physical display hardware and input devices.
- **Hardware level:** Runs directly in kernel space via the kernel framebuffers or VGA console driver.
- **Keybinding:** Switching between VTs is handled directly by the kernel via `Ctrl + Alt + F1` through `F12`.

### B. Standard Kernel Consoles: `getty` / `agetty`
- **What it is:** The standard text-based login prompt program (`/sbin/agetty`).
- **How it works:** It connects to a raw kernel Virtual Terminal (`/dev/ttyN`), initializes the line speed/environment, prints the `login:` prompt, and executes `login` / `pam` upon credential entry.
- **Init Integration:** Managed by systemd through standard template unit files (`getty@ttyN.service`).

### C. GPU-Accelerated Userspace Consoles: `kmscon`
- **What it is:** A modern replacement for the kernel console that runs in userspace. It uses Linux DRM/KMS (Direct Rendering Manager / Kernel Mode Setting) and EGL/OpenGL for hardware-accelerated text rendering, custom fonts, Unicode/UTF-8 support, and multi-monitor setups.
- **How it works:** 
  - Like Hyprland or Xorg, `kmscon` takes control of the DRM device (`/dev/dri/card0`).
  - Because it is a userspace application, terminal windows or shells spawned inside `kmscon` interact via Pseudo-Terminals (`/dev/pts/N`), whereas traditional `getty` communicates directly over physical `/dev/ttyN`.
- **Alternatives in this category:** `kmscon`, `fbterm`, `yaft`.

### D. Graphical Display Managers: `sddm` / `gdm` / `lightdm`
- **What they are:** Graphical login greeters and session managers (e.g., **SDDM** for KDE/Hyprland, **GDM** for GNOME, **LightDM** for X11/Xfce).
- **How they work with VTs:**
  - Display Managers allocate real kernel VTs for their greeters and desktop sessions.
  - They request a free VT (e.g., TTY 1 or TTY 2), launch an X11 server or Wayland compositor (like Hyprland), and hand over DRM master control to that session.

### E. Terminal Emulators inside GUI: `pts` (Pseudo-Terminals)
- **What it is:** Software terminals running inside a Wayland/X11 GUI (such as `kitty`, `foot`, `alacritty`, `wezterm`).
- **Why `tty` shows `/dev/pts/N` inside Hyprland:** Hyprland itself occupies the underlying physical VT (e.g., `/dev/tty4`), but your shell inside a GUI terminal window executes under a kernel pseudo-terminal slave (`/dev/pts/8`).

---

## 2. Categorization of Terminal & Greeter Types

| Category | Core Technology | GPU Accel? | Example Software | TTY Device Type |
|---|---|---|---|---|
| **Kernel Console (Traditional)** | Linux Kernel VT + PAM | ❌ No (Framebuffer/VGA) | `agetty`, `mgetty`, `fgetty` | `/dev/tty1` – `/dev/tty12` |
| **Userspace KMS Console** | DRM/KMS + OpenGL/EGL | ✅ Yes (GPU accelerated) | `kmscon`, `fbterm`, `yaft` | `/dev/pts/N` via `/dev/ttyN` VT takeover |
| **Graphical Display Manager** | Wayland / X11 + Qt/GTK | ✅ Yes (Full 3D / Wayland) | **SDDM**, **GDM**, **LightDM** | Manages `/dev/tty1` – `/dev/tty4` |
| **GUI Terminal Emulator** | Wayland/X11 Client | ✅ Yes (Mesa/OpenGL) | Kitty, Foot, Alacritty, WezTerm | `/dev/pts/N` |

---

## 3. Current System Layout (This Machine)

Currently, the 12 Virtual Terminals on this machine are segmented as follows:

| TTY Index | Occupant / Manager | Technology | Purpose |
|---|---|---|---|
| **TTY 1** | Free / GRUB Log | Kernel Framebuffer | Preserved for boot/kernel logs |
| **TTY 2** | **SDDM Greeter** | X11 / Qt6 | Graphical Login Interface |
| **TTY 3** | **Hyprland Desktop** | Wayland / DRM | Main Graphical User Session |
| **TTY 4** | Reserved for SDDM | Wayland / X11 | Free for secondary graphical sessions |
| **TTY 5** | `kmscon` (`kmsconvt@tty5.service`) | DRM/KMS Userspace | GPU-accelerated console |
| **TTY 6** | `kmscon` (`kmsconvt@tty6.service`) | DRM/KMS Userspace | GPU-accelerated console |
| **TTY 7** | `kmscon` (`kmsconvt@tty7.service`) | DRM/KMS Userspace | GPU-accelerated console |
| **TTY 8** | `kmscon` (`kmsconvt@tty8.service`) | DRM/KMS Userspace | GPU-accelerated console |
| **TTY 9** | `getty` (`getty@tty9.service`) | Kernel Console | Traditional text console |
| **TTY 10** | `getty` (`getty@tty10.service`) | Kernel Console | Traditional text console |
| **TTY 11** | `getty` (`getty@tty11.service`) | Kernel Console | Traditional text console |
| **TTY 12** | `getty` (`getty@tty12.service`) | Kernel Console | Traditional text console |

---

## 4. State Management: Passive (Config) vs. Active (Systemd)

Console services and display managers can be managed either **actively** (via `systemctl` commands in real time) or **passively** (via persistent configuration files across reboots).

### A. Kernel-based `getty` Management

#### Active Management (Commands):
```bash
# Enable and start getty on TTY 9
sudo systemctl enable --now getty@tty9.service

# Stop and disable getty on TTY 1
sudo systemctl disable --now getty@tty1.service

# Check status of getty on TTY 9
systemctl status getty@tty9.service
```

#### Passive Configuration (Files):
To control how systemd autospawns `getty` consoles on demand across reboots, edit `/etc/systemd/logind.conf` or add an override in `/etc/systemd/logind.conf.d/`:

```ini
# /etc/systemd/logind.conf.d/getty-config.conf
[Login]
# Number of VTs to allocate for autospawning gettys (e.g. 6 means tty1..tty6)
NAutoVTs=6

# Explicitly reserve a VT for emergency rescue getty (default is tty6)
ReserveVT=6
```

---

### B. GPU-based `kmscon` Management

#### Active Management (Commands):
```bash
# Enable and start kmscon on TTY 5
sudo systemctl enable --now kmsconvt@tty5.service

# Stop and disable kmscon on TTY 1 (prevents DRM conflict with SDDM)
sudo systemctl disable --now kmsconvt@tty1.service

# List all active kmscon units
systemctl list-units 'kmsconvt*'
```

#### Passive Configuration (Files):
To make `kmscon` replace default systemd `getty` instances passively, edit `/etc/kmscon/kmscon.conf`:

```ini
# /etc/kmscon/kmscon.conf
font-name=DejaVu Sans Mono
font-size=14
hwaccel=1
drm=1
```

Or configure systemd autospawning to use `kmsconvt@.service` instead of `getty@.service`:
```bash
# Link kmscon as the primary console generator in logind
sudo systemctl enable kmsconvt@.service
```

---

### C. Display Managers (SDDM / GDM) Management

#### Active Management (Commands):
```bash
# Start or restart SDDM greeter
sudo systemctl restart sddm.service

# Enable SDDM as the primary display manager at boot
sudo systemctl enable sddm.service

# Switch active display manager to GDM (if installed)
sudo systemctl disable --now sddm.service
sudo systemctl enable --now gdm.service
```

#### Passive Configuration (Files):

**For SDDM (`/etc/sddm.conf.d/vt.conf`):**
Controls which VT index SDDM starts allocation from:
```ini
# /etc/sddm.conf.d/vt.conf
[X11]
MinimumVT=2

[Wayland]
MinimumVT=2
```
*Setting `MinimumVT=2` leaves TTY 1 free for GRUB/kernel boot logs, while dedicating TTY 2, 3, 4 to SDDM and Hyprland.*

**For GDM (`/etc/gdm3/daemon.conf`):**
```ini
# /etc/gdm3/daemon.conf
[daemon]
WaylandEnable=true
# GDM by default allocates on TTY 1 for greeter and TTY 2+ for sessions
```

---

## 5. Identifying Physical TTY from GUI (`/dev/pts`)
Inside GUI terminal emulators (Kitty/Foot/Alacritty), `tty` outputs a pseudo-terminal (`/dev/pts/N`). To resolve the underlying physical VT (`ttyN`) across any freedesktop/systemd compliant desktop environment (Hyprland, KDE, GNOME, XFCE):

### Unified Standard Method (`loginctl`)
```bash
# Query active session TTY via systemd-logind (freedesktop spec)
loginctl show-session $XDG_SESSION_ID -p TTY --value
```

### Alternative Methods
```bash
# 1. Environment variable (set by PAM/Display Managers)
echo $XDG_VTNR

# 2. Detailed session inspection
loginctl session-status $XDG_SESSION_ID | grep -i "seat\|tty"
```

### Quick Shell Alias
```bash
alias mytty='loginctl show-session $XDG_SESSION_ID -p TTY --value'
```

---

## 6. Summary Rules for System Stability
1. **Never overlap DRM consumers:** Do NOT run `kmscon` on the same TTY ranges assigned to SDDM/GDM/Hyprland (e.g. keep `kmscon` on TTY 5–8 and SDDM on TTY 1–4).
2. **Leave TTY 1 for Boot Logs (Optional):** Setting `MinimumVT=2` in SDDM leaves TTY 1 clean for kernel/GRUB boot messages.
3. **Use `/etc/systemd/system/getty.target.wants/`:** Systemd uses symlinks in this directory to passively determine which TTYs get `getty` vs `kmscon` at boot time.

