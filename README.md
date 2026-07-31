<div align="center">

# 🔮 corechunk / hyprland
### *Modular Hyprland Wayland Compositor Configuration*

> ⚠️ **Active development. Installation NOT recommended. Use at your own risk.**

---

[![Version](https://img.shields.io/badge/version-dev-orange?style=for-the-badge&logo=gitbook&logoColor=white)](https://github.com/corechunk/hyprland)
[![Shell](https://img.shields.io/badge/shell-bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/platform-wayland-blue?style=for-the-badge&logo=linux&logoColor=white)](https://wayland.freedesktop.org/)
[![Hyprland](https://img.shields.io/badge/built_for-hyprland-58E1FF?style=for-the-badge)](https://hyprland.org/)
[![License](https://img.shields.io/badge/license-MIT-red?style=for-the-badge)](./LICENSE)

[📖 Overview](#-overview) • [🛠️ Software](#-used-software--tools) • [📂 Structure](#%EF%B8%8F-repository-structure) • [📦 Installation](#-installation) • [🌐 Full Setup](#-full-environment-setup) • [⚙️ Conventions](#%EF%B8%8F-development-conventions)

---

</div>

## 📖 Overview

This is a personal dotfiles repository for the [Hyprland](https://github.com/hyprwm/hyprland) Wayland compositor by hyprwm — not the compositor itself. It contains configuration files, scripts, and presets that run on top of Hyprland to build a complete, opinionated desktop environment.

The setup is highly modular, split into focused `.conf` files and categorized shell scripts, all expected to live at `$HOME/.config/hypr`. Managed as a sub-repository of [shard](https://github.com/corechunk/shard), the central dotfile orchestrator, but fully usable standalone.

---

## 🛠️ Used Software & Tools

### Launchers & Menus
- **rofi** — Application launcher and clipboard history menu.
- **waybar** — Customizable Wayland status bar.
- **nm-applet** — Network manager applet.

### System & Utilities
- **hyprctl** — Hyprland control utility.
- **wl-clipboard** — Clipboard (`wl-copy`, `wl-paste`).
- **cliphist** — Clipboard history manager.
- **swaync** — Notification daemon.
- **grim / slurp** — Screenshot and region selector.
- **kitty** — Terminal emulator.
- **thunar / ranger** — GUI and console file managers.
- **pypr** — Pyprland scratchpad manager.

### Appearance
- **hyprpaper** — Wallpaper utility.

---

## 🗂️ Repository Structure

```text
hyprland/
├── hypr/
│   ├── hyprland.conf           # Main entry point (sources all configs)
│   ├── hyprlock.conf           # Lock screen config
│   ├── hyprpaper.conf          # Wallpaper config
│   ├── configs/
│   │   ├── animations/         # Window, layer & workspace animation presets
│   │   ├── keybindings/        # Split keybinding categories
│   │   ├── decorations.conf
│   │   ├── inputs.conf
│   │   ├── variables.conf      # Common app paths & settings
│   │   └── ...
│   └── scripts/
│       ├── animations/         # Runtime animation switchers
│       ├── screenshot/         # Screenshot utilities
│       ├── startup/            # Startup helpers
│       ├── utils/              # Dock, logout, shortcuts
│       └── wallpaper/          # Wallpaper selection & patched picker
├── pypr/                       # Pyprland scratchpad config
├── xtra/                       # Extra install helpers (rofi, quickshell)
├── dev.sh                      # Dev install script (DESTRUCTIVE)
└── installer_hyprland_dots.sh  # Main installer
```

---

## 📦 Installation

> ⚠️ **The `dev.sh` script will DELETE your existing `~/.config/hypr` and replace it. Use with extreme caution.**

```bash
git clone https://github.com/corechunk/hyprland.git
cd hyprland
chmod +x installer_hyprland_dots.sh
./installer_hyprland_dots.sh
```

After install, reload Hyprland: `SUPER + R`

---

## 🌐 Full Environment Setup

This repo covers only the **Hyprland layer** of the environment. For the complete setup — including Waybar, Neovim, Kitty, Tmux, Oh-My-Posh, Wallpapers, and more — head over to the central orchestrator:

> 👉 **[corechunk/shard](https://github.com/corechunk/shard)** — pulls and deploys all dotfiles as versioned bundles.

### Required
These must be installed for the config to function:

| Package | Purpose |
| :--- | :--- |
| **hyprland** | The compositor itself (hyprwm/hyprland) |
| **hyprpaper** | Wallpaper rendering |
| **kitty** | Default terminal |
| **rofi** | App launcher & clipboard menu |
| **waybar** | Status bar |
| **grim + slurp** | Screenshots |
| **wl-clipboard** | Clipboard support |
| **cliphist** | Clipboard history |
| **swaync** | Notification daemon |
| **git** | For installer & vault sync |

### Optional
Nice to have but not required:

| Package | Purpose |
| :--- | :--- |
| **pypr** | Scratchpad manager |
| **thunar** | GUI file manager |
| **ranger** | Console file manager |
| **nm-applet** | Network tray applet |
| **firefox** | Default browser in binds |

---

## ⚙️ Development Conventions

- **Modularity** — Config is split into focused files (`animations.conf`, `keybindings.conf`, `variables.conf`, etc.).
- **Variables** — Common app paths and settings are defined in `hypr/configs/variables.conf`.
- **Scripts** — All custom logic lives in `hypr/scripts/`, organized by category.
- **Keybindings** — Defined in `hypr/configs/keybindings.conf` and split further under `keybindings/`.

---

## 🤝 Contributing

Feel free to open an issue or pull request. This config is experimental — feedback and testing help.

---

## 📜 License
This repository is licensed under the [MIT License](LICENSE).

---

<div align="center">

### 🪐 orbit around your workflow
Built with ❤️ by [netchunk](https://github.com/netchunk)

[![GitHub](https://img.shields.io/badge/Back_to_Hyprland-181717?style=for-the-badge&logo=github)](https://github.com/corechunk/hyprland)
[![X](https://img.shields.io/badge/Connect_on_X-1DA1F2?style=for-the-badge&logo=x)](https://x.com/Mahmudul__Miraj)

[Back to Top](#-corechunk--hyprland)

</div>