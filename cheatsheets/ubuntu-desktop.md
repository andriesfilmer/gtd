# Ubuntu desktop

## Nvidia drivers

Detect the model of your nvidia graphic card and the recommended driver.

    ubuntu-drivers devices

## Gnome

### Extentions

I like [gTile extention](https://extensions.gnome.org/extension/28/gtile/) adjusted the  `Resize presets` for `Super+Alt+[KP_1..KP_9]` for my monitor with 5120x1440 resolution.

* Preset resize 4: `3x1 0:0 0:0,0:0 1:0`
* Preset resize 5: `3x1 1:0 1:0,0:0 2:0`
* Preset resize 6: `3x1 2:0 2:0,1:0 2:0`

### gnome-tweaks

    sudo apt-get install gnome-tweak-tool

### dconf-editor

Very fast & easy, without any installations/extensions:

#### ALT-TAB cycle through apps on current workspace only.

    dconf-editor -> org/gnome/shell/app-switcher/

or
    gsettings set org.gnome.shell.app-switcher current-workspace-only true


### Scaling 4k monitors with wayland (2019)

#### X11

    gsettings set org.gnome.desktop.interface text-scaling-factor 1.25

#### Wayland
    gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
    gsettings reset org.gnome.mutter experimental-features

## Davfs

    sudo apt install davfs2
    usermod -aG davfs2 `user`
    mkdir ~/stack ~/.davfs2
    chown `user`:`group` ~/.davfs2/secrets
    chmod 600 ~/.davfs2/secrets
    vi ~/.davfs/secrets
        https://discnaam.stackstorage.com/remote.php/webdav/ Test1 test123
    sudo vi /etc/fstab
        https://discnaam.stackstorage.com/remote.php/webdav/ /home/<gebruiker>/stack davfs user,rw,noauto 0 0
    mount ~/stack


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

## Keyboard layout

    sudo dpkg-reconfigure keyboard-configuration
    gsettings reset org.gnome.desktop.input-sources xkb-options
?
    sudo service keyboard-setup restart
    sudo setupcon

## Display scalling
Via de algemene instellingen kan je het voor het hele systeem aanpassen via:

Settings -> Display: Scale for menu and title bars: 1.25

### Firefox

For firefox type in the address `about:config`.

    set layout.css.devPixelsPerPx: 1.25

### Thunderbird

For Thunderbird go to: Prefrences -> Advanced -> Config Editor:

    set layout.css.devPixelsPerPx: 1.25
