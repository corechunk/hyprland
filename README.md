# hyprland
My Hyprland dotfiles [unofficial distribution]

## Project Overview

This repository contains personal dotfiles for configuring the Hyprland Wayland compositor. The configuration is highly modular, with different aspects of the setup broken down into separate `.conf` files. This makes it easy to manage and customize.

The core of the configuration is in the `hypr` directory, which is expected to be located at `$HOME/.config/hypr`. The main entry point is `hyprland.conf`, which sources all other configuration files.

## Key Technologies Used

This Hyprland configuration leverages a variety of external software and scripts to provide a rich and customized desktop experience. Below is a categorized list of the key technologies utilized:

### Launchers & Menus
*   **rofi:** A versatile application launcher and menu. Used for the main application menu (`drun`) and for displaying the clipboard history.
*   **waybar:** A highly customizable Wayland bar for displaying information and workspaces.
*   **nm-applet:** A network manager applet for managing network connections.

### System & Utilities
*   **hyprctl:** The command-line utility for controlling Hyprland.
*   **wl-clipboard:** A command-line tool for interacting with the Wayland clipboard. Includes `wl-copy` and `wl-paste`.
*   **yad:** (Yet Another Dialog) A command-line tool to display GTK+ dialogs, used for displaying cheat sheets.
*   **cliphist:** A clipboard history manager for Wayland.
*   **swaync:** A notification daemon for Wayland.
*   **grim:** A command-line tool for taking screenshots on Wayland.
*   **slurp:** A command-line tool for selecting a region on Wayland, used with `grim` for region screenshots.
*   **swappy:** A tool for editing and annotating screenshots (used in commented-out examples).
*   **kitty:** A fast, feature-rich, GPU-based terminal emulator.
*   **thunar:** A modern and lightweight file manager for Xfce, used as the primary file manager.
*   **ranger:** A console file manager with VI key bindings, available as an alternative.
*   **firefox:** A popular open-source web browser.
*   **microsoft-edge-stable:** The stable version of Microsoft Edge for Linux (commented out).
*   **git:** A distributed version control system.
*   **Standard Unix Utilities:** `killall`, `sleep`, `sed`, `grep`, `find`, `xargs`, `bash`, `sh`, `tee`, `date`.

### Appearance & Session
*   **hyprpaper:** A wallpaper utility for Hyprland.
*   **swww-daemon:** A wallpaper daemon that supports animated wallpapers.
*   **mpvpaper:** A tool for using `mpv` to play videos as wallpapers.

## Building and Running

There is no formal build process. The configuration is installed by copying the `hypr` directory to `$HOME/.config/hypr`.

**WARNING:** The `dev.sh` script contains a destructive command that will delete the existing Hyprland configuration (`$HOME/.config/hypr`) and replace it with the contents of this repository. Use with caution.

To install the configuration:

1.  Make sure you have the necessary dependencies installed (see this `README.md`).
2.  Run the `dev.sh` script and choose option 1:

    ```bash
    ./dev.sh
    ```

After installation, Hyprland needs to be reloaded. This can be done by pressing `SUPER + R`.

## Development Conventions

- **Modularity:** The configuration is split into many small files, each with a specific purpose (e.g., `animations.conf`, `keybindings.conf`, `variables.conf`).
- **Variables:** The `hypr/configs/variables.conf` file is used to define variables for commonly used applications and settings. This makes it easy to customize the environment without having to search through multiple files.
- **Scripts:** Custom functionality is implemented in shell scripts located in the `hypr/scripts` directory. These scripts are called from the Hyprland configuration, usually via keybindings.
- **Keybindings:** Keybindings are defined in `hypr/configs/keybindings.conf` and are organized into separate files for different categories of actions.