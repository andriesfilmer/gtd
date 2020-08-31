# Ubuntu desktop

## Nvidia drivers

Detect the model of your nvidia graphic card and the recommended driver.

    ubuntu-drivers devices

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

