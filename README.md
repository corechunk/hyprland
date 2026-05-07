# Hyprland Dotfiles (Development)

**⚠️ These dotfiles are in active development. Installation is NOT recommended. Use at your own risk.**

## Overview

This repository contains personal configuration files for the Hyprland Wayland compositor. The setup is modular, with configuration split into multiple `.conf` files and supporting scripts. The main configuration directory is expected at `$HOME/.config/hypr`.

## Status

- **Work in progress:** The configuration is experimental and subject to frequent changes.
- **Not for general use:** Please do not install unless you are familiar with Hyprland and want to help with development or testing.

## Used Software & Tools

The following software is actively used in the configuration and scripts:

### Launchers & Menus
- **rofi:** Application launcher and menu (used for launching apps and clipboard history).
- **waybar:** Customizable status bar for Wayland.
- **nm-applet:** Network manager applet.

### System & Utilities
- **hyprctl:** Hyprland control utility.
- **wl-clipboard:** Clipboard utilities (`wl-copy`, `wl-paste`).
- **cliphist:** Clipboard history manager.
- **swaync:** Notification daemon.
- **grim:** Screenshot tool.
- **slurp:** Region selector for screenshots.
- **kitty:** Terminal emulator.
- **thunar:** File manager.
- **ranger:** Console file manager (alternative).
- **firefox:** Web browser.
- **git:** Version control.
- **Standard Unix Utilities:** `killall`, `sleep`, `sed`, `grep`, `find`, `xargs`, `bash`, `sh`, `tee`, `date`.

### Appearance
- **hyprpaper:** Wallpaper utility.

## Development Conventions

- **Modularity:** Configuration is split into focused files (e.g., `animations.conf`, `keybindings.conf`, `variables.conf`).
- **Variables:** Common settings and application paths are defined in `hypr/configs/variables.conf`.
- **Scripts:** Custom scripts are in `hypr/scripts` and called via keybindings or other config entries.
- **Keybindings:** Defined in `hypr/configs/keybindings.conf` and related files.

## Installation

**Do not install these dotfiles unless you are developing or testing.**

The included scripts (`dev.sh`, etc.) are destructive and will overwrite your existing Hyprland configuration.

## Contributing

If you wish to contribute, please open an issue or pull request.

---
*This README will be updated as development progresses.*