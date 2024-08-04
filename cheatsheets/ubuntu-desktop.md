# Ubuntu desktop

## Nvidia drivers

Detect the model of your nvidia graphic card and the recommended driver.

    ubuntu-drivers devices

## Gnome

### gsetting

    # Simple theme settings dark and light
    gsettings set org.gnome.desktop.interface color-scheme [default | prefer-dark | prefer-light]

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

    # Set terminal cursor from 'block' -> 'ibeam'. First get your profile-id
    gsettings get org.gnome.Terminal.ProfilesList list
    # Replace <profile-id> with your profile ID from the previous command's output:
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/<profile-id>/ cursor-shape 'ibeam'

    sudo apt install wl-copy

    # Create the Copy Keybinding (Ctrl + Insert):
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Copy with Ctrl+Insert'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'wl-copy < /dev/stdin'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Primary>Insert'

    # Create the Paste Keybinding (Shift + Insert):
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ name 'Paste with Shift+Insert'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ command 'wl-paste'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding '<Shift>Insert'


### gnome-tweaks

    sudo apt-get install gnome-tweak-tool

### Extentions

I like [gTile extention](https://extensions.gnome.org/extension/28/gtile/) adjusted the  `Resize presets` for `Super+Alt+[KP_1..KP_9]` for my monitor with 5120x1440 resolution.

* Preset resize 4: `3x1 0:0 0:0,0:0 1:0`
* Preset resize 5: `3x1 1:0 1:0,0:0 2:0`
* Preset resize 6: `3x1 2:0 2:0,1:0 2:0`

User-defined shortcuts does not work after upgrade

    dconf dump /org/gnome/shell/extensions/gtile/ | perl -p -e "s/(\d+):(\d+)/(\$1+1).':'.(\$2+1)/ge" | dconf load /org/gnome/shell/extensions/gtile/

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


## Scanner not found

LAN-based scanners - The scanner is connected directly to the network without any intermediary computer.

HP All-in-One devices

    sudo apt-get install hplip

Run the hp-setup wizard which installs printer, scanner, and any other features.

    sudo hp-setup

For Connection Type choose "Network/Ethernet..."

If the device is not detected, click "Show advanced options", tick "Manual discovery" and supply the scanner's IP address.

Check the scanner is now recognized:

    scanimage -L


## Display scalling (X)

Via de algemene instellingen kan je het voor het hele systeem aanpassen via:

Settings -> Display: Scale for menu and title bars: 1.25

### Firefox

For firefox type in the address `about:config`.

    set layout.css.devPixelsPerPx: 1.25

### Thunderbird

For Thunderbird go to: Prefrences -> Advanced -> Config Editor:

    set layout.css.devPixelsPerPx: 1.25

### Opening applications on startup

Example: Reset Thunderbird position on startup

    xdotool search --name "Mozilla Thunderbird" windowmove 0 0

## Webcam zoom

    v4l2-ctl -d /dev/video0 -c zoom_absolute=200
