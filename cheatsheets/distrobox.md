# Distrobox

* <https://distrobox.it/>

## Install

    # Dependencie
    sudo apt install podman

    curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh

## Create a container

    distrobox create -n ubuntubox --image ubuntu:24.04
    distrobox create -n ubuntubox --image ubuntu:24.04 --volume /your/custom/volume/path

### Create a clone

    distrobox create --name test --clone name-of-distrobox-to-clone

## Run a container

    distrobox enter ubuntubox

    cat /etc/os-release


## Export app

    distrobox-export --app gimp


## Remove

    distrobox stop ubuntubox
    distrobox rm ubuntubox


## Tips

### Custom terminal shortcut

1 - Create a new terminal profile for example `Distrobox'

* Custom command: `distrobox-enter -n ubuntubox`

2 - Create a shortcut `Super+t`

* Open the Keyboard settings on your system.
* Go to the Shortcuts tab and add a new custom shortcut `Super+t`.
* Set the command to open the terminal with the specific profile. For example:

    gnome-terminal --window-with-profile=Distrobox

* <https://github.com/89luca89/distrobox/blob/main/docs/useful_tips.md>
