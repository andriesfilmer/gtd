- [Ubuntu desktop](#ubuntu-desktop)
  * [Basics](#basics)
  * [Locale](#locale)
  * [Personal gsetting](#personal-gsetting)
  * [Gnome Extentions](#gnome-extentions)
  * [Nice applications to install](#nice-applications-to-install)
  * [Thunderbird](#thunderbird)
  * [Nvidia drivers](#nvidia-drivers)
  * [How to reset lost root password (single usermode)](#how-to-reset-lost-root-password-single-usermode)
  * [Some know-abouts](#some-know-abouts)
    + [Opening applications on position on startup](#opening-applications-on-position-on-startup)
  * [Webcam zoom](#webcam-zoom)

<!-- END TOC -->

# Ubuntu desktop

## Basics

    sudo apt install gnome-tweak-tool
    sudo apt install gnome-shell-extensions
    sudo apt install build-essential
    sudo apt install vim
    sudo apt install dconf-editor
    sudo apt install aspell-nl
    sudo apt install imagemagick
    sudo apt install vlc
    sudo apt install pngquant
    sudo apt install libreoffice
    sudo apt install nautilus-image-converter

## Locale

After installing dutch language via settings it did not work. I had to run the next command first en reboot.

   sudo locale-gen

## Personal gsetting

    # Settings -> Keyboard -> Keyboard Shortcuts -> Custom Shortcuts -> +

    # Remap the Capslock key to Esc but Shift + Caps Lock behaves like regular Caps Lock
    gsettings set org.gnome.desktop.input-sources xkb-options \[\'caps:escape_shifted_capslock\'\]

    # prefer-light theme shortcut
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name "'Light theme'"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding "'F9'"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command "'gsettings set org.gnome.desktop.interface color-scheme prefer-light'"

    # prefer-dark theme shortcuts
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name "'Dark theme'"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command "'gsettings set org.gnome.desktop.interface color-scheme prefer-dark'"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "'F10'"

    # Sound off when working in terminal
    gsettings set org.gnome.desktop.sound event-sounds false

    # Alt-Tilde cycle in all workspaces
    gsettings set org.gnome.shell.app-switcher current-workspace-only false
    # Alt-Tab cycle in current workspace
    gsettings set org.gnome.shell.window-switcher current-workspace-only true

    # Show icons with dots in dock on all workspaces
    gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces false
    # Fix the workspaces to 4
    gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
    gsettings set org.gnome.mutter dynamic-workspaces false

    # Disable user list, user needs to type username
    gsettings org.gnome.login-screen.disable-user-list true
    gsettings org.gnome.login-screen.disable-user-list true

    # Set cursor size bigger from 24 -> 36 on large screen.
    gsettings set org.gnome.desktop.interface cursor-size 36

Use `dconf-editor` to change it manual.

## Gnome Extentions

[gTile extention](https://extensions.gnome.org/extension/28/gtile/) adjusted the  `Resize presets` for `Super+Alt+[KP_1..KP_9]` for my monitor with 5120x1440 resolution.

    cat ~/gtd/scripts/gnome/gTile.conf | dconf load /org/gnome/shell/extensions/gtile/

[Smart-auto-move](https://extensions.gnome.org/extension/4736/smart-auto-move/) Learns the position,
size, and workspace of your application windows and restores them on subsequent launches. Supports Wayland.

[Clipboard History](https://extensions.gnome.org/extension/4839/clipboard-history/)

[Dim background windows](https://extensions.gnome.org/extension/6313/dim-background-windows/)

## Nice applications to install
* [Espanso Autokey](https://espanso.org/docs/) | Supercharge your typing experience
* [Qownnotes](https://snapcraft.io/qownnotes) | Markdown editer and viewer
* [Foliate](https://snapcraft.io/foliate) | E-book reader
* [SweetHome3D](https://snapcraft.io/install/sweethome3d-homedesign/ubuntu) | Draw house plans

## Thunderbird

Compose font size: Edit -> Settings -> Font & Colors -> Advanced -> Fonts for: Other writing systems, and set monospace: Size 20.

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
