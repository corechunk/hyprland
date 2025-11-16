# Project Overview

This repository contains personal dotfiles for configuring the Hyprland Wayland compositor. The configuration is highly modular, with different aspects of the setup broken down into separate `.conf` files. This makes it easy to manage and customize.

The core of the configuration is in the `hypr` directory, which is expected to be located at `$HOME/.config/hypr`. The main entry point is `hyprland.conf`, which sources all other configuration files.

Key technologies used include:
- **Hyprland:** The Wayland compositor.
- **rofi:** Used for application launching and interactive menus (e.g., wallpaper selection).
- **grim & slurp:** Used for taking screenshots.
- **wl-clipboard:** For clipboard management.
- **kitty:** The default terminal.
- **thunar:** The default file manager.

# Building and Running

There is no formal build process. The configuration is installed by copying the `hypr` directory to `$HOME/.config/hypr`.

**WARNING:** The `dev.sh` script contains a destructive command that will delete the existing Hyprland configuration (`$HOME/.config/hypr`) and replace it with the contents of this repository. Use with caution.

To install the configuration:

1.  Make sure you have the necessary dependencies installed (see `README.md`).
2.  Run the `dev.sh` script and choose option 1:

```bash
./dev.sh
```

After installation, Hyprland needs to be reloaded. This can be done by pressing `SUPER + R`.

# Development Conventions

- **Modularity:** The configuration is split into many small files, each with a specific purpose (e.g., `animations.conf`, `keybindings.conf`, `variables.conf`). This is the main convention of the project.
- **Variables:** The `hypr/configs/variables.conf` file is used to define variables for commonly used applications and settings. This makes it easy to customize the environment without having to search through multiple files.
- **Scripts:** Custom functionality is implemented in shell scripts located in the `hypr/scripts` directory. These scripts are called from the Hyprland configuration, usually via keybindings.
- **Keybindings:** Keybindings are defined in `hypr/configs/keybindings.conf` and are organized into separate files for different categories of actions.
