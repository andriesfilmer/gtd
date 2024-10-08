# Ubuntu desktop

## Basics

    sudo apt install vim nvim
    sudo apt install dconf-editor
    sudo apt install gnome-tweak-tool

## Personal gsetting

Use `dconf-editor` to change it manual.

    # prefer-light theme shortcut
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Light theme'"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'F9'"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'gsettings set org.gnome.desktop.interface color-scheme prefer-light'"

    # prefer-dark theme shortcuts
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "'Dark theme'"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'gsettings set org.gnome.desktop.interface color-scheme prefer-dark'"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "'F10'"

    # Sound off when tabbing in terminal
    gsettings set org.gnome.desktop.sound event-sounds false

    # Alt-Tilde cycle in all workspaces
    gsettings set org.gnome.shell.app-switcher current-workspace-only true
    # Alt-Tab cycle in current workspace
    gsettings set org.gnome.shell.window-switcher current-workspace-only true

    # Keyboard layout -> English (intl., with AltGr dead keys)
    gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us+altgr-intl')]"
    # Restore keyboard settings if broken.
    gsettings reset org.gnome.desktop.input-sources xkb-options

    # Remapping the Most Useless Key on Linux (Caps Lock) to Esc, Especially for vimmers.
    #gsettings set org.gnome.desktop.input-sources xkb-options "['lv3:ralt_switch','caps:escape_shifted_capslock']"
    gsettings set org.gnome.desktop.input-sources xkb-options "['caps:escape_shifted_capslock']"

    # Do we need this? Configure keyboard configuration -> Dell 101-key PC
    sudo dpkg-reconfigure keyboard-configuration

    # Set cursor size bigger from 24 -> 36 on large screen.
    gsettings set org.gnome.desktop.interface cursor-size 36


## Gnome Extentions

I like [gTile extention](https://extensions.gnome.org/extension/28/gtile/) adjusted the  `Resize presets` for `Super+Alt+[KP_1..KP_9]` for my monitor with 5120x1440 resolution.

    cat ~/gtd/scripts/gnome/gTile.conf | dconf load /org/gnome/shell/extensions/gtile/

## Nice applications to install
* [Espanso Autokey](https://espanso.org/docs/) | Supercharge your typing experience
* [Qownnotes](https://snapcraft.io/qownnotes) | Markdown editer and viewer
* [Foliate](https://snapcraft.io/foliate) | E-book reader
* [SweetHome3D](https://snapcraft.io/install/sweethome3d-homedesign/ubuntu) | Draw house plans


## Nvidia drivers

Detect the model of your nvidia graphic card and the recommended driver.

    ubuntu-drivers devices

## How to reset lost root password (single usermode)

On Ubuntu 18.04 Bionic Beaver Linux

* Keep hitting LEFT SHIFT for the GRUB menu to show up
* Select in the Ubuntu menu 'Advanced options for Ubuntu'e key. This will allow you to edit the menu:
* Hit the `e` key to edit the boot params
* Navigate down until you can see a line ending with: `ro   quiet splash $vt_handoff`
* Change this to: `rw init=/bin/bash`
* Press F10 or CTRL + x to perform boot into a single mode.
* Mount the partion as read/write (rw): `mount | grep -w /`
* Reboot your system: `exec /sbin/init`


## Some know-abouts

### Opening applications on position on startup

Example: Reset Thunderbird position on startup

    xdotool search --name "Mozilla Thunderbird" windowmove 0 0

## Webcam zoom

    v4l2-ctl -d /dev/video0 -c zoom_absolute=200

