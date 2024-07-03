## Install

    sudo curl -l -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
    sudo update
    sudo apt install syncthing

## Auto start

### Run as user

create a [systemd service](https://github.com/syncthing/syncthing/tree/main/etc)

    systemctl enable syncthing@username.service
    systemctl start syncthing@username@andries

open a browser on: http://127.0.0.1:8384/#

### Run server daemon

    adduser syncthing
    vi /etc/systemd/system/syncthing@syncthing.service
    systemctl enable syncthing@syncthing.service --now

* <https://docs.syncthing.net/users/autostart.html#linux>
* <https://docs.syncthing.net/users/faq.html#how-do-i-run-syncthing-as-a-daemon-process-on-linux>


## config

    syncthing generate --gui-user=andries --gui-password=some-user-password

You can also see and change the config file

    cat /root/.local/state/syncthing/config.xml
