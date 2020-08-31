# Gnome

## gnome-tweaks

    sudo apt-get install gnome-tweak-tool

## Extentions

### WinTile

<https://extensions.gnome.org/extension/1723/wintile-windows-10-window-tiling-for-gnome/>

## dconf-editor

Very fast & easy, without any installations/extensions:

### ALT-TAB cycle through apps on current workspace only.

    dconf-editor -> org/gnome/shell/app-switcher/

or
    gsettings set org.gnome.shell.app-switcher current-workspace-only true


## Scaling 4k monitors with wayland

### X11

    gsettings set org.gnome.desktop.interface text-scaling-factor 1.25

### Wayland
    gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
    gsettings reset org.gnome.mutter experimental-features
