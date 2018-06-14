# Gnome

## gnome-tweaks

    sudo apt-get install gnome-tweak-tool

## dconf-editor

Very fast & easy, without any installations/extensions:

### ALT-TAB cycle through apps on current workspace only.

    dconf-editor -> org/gnome/shell/app-switcher/

or
    gsettings set org.gnome.shell.app-switcher current-workspace-only true


## Scaling 4k monitors with wayland

    gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
    gsettings reset org.gnome.mutter experimental-features