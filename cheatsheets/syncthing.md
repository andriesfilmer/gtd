## Install

    sudo curl -l -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
    sudo apt update
    sudo apt install syncthing

### Macbook

    brew install syncthing

## Auto start

### Run as user

create a [systemd user service](~/gtd/config/syncthing@username.service)

**Where `username` is your username!**

    cp ~/gtd/config/syncthing@username.service /etc/systemd/system/syncthing@username.service
    systemctl enable syncthing@username.service
    systemctl start syncthing@username.service

Open a browser on: http://127.0.0.1:8384/#

### Run server daemon

    adduser syncthing
    vi /etc/systemd/system/syncthing@syncthing.service
    systemctl enable syncthing@syncthing.service --now

* <https://docs.syncthing.net/users/autostart.html#linux>
* <https://docs.syncthing.net/users/faq.html#how-do-i-run-syncthing-as-a-daemon-process-on-linux>


## Set gui user and password

    syncthing generate --gui-user=andries --gui-password=some-user-password

## config

You can also see and change the config file

    vi /home/syncthing/.local/state/syncthing/config.xml


## nginx
````
server {
  listen 443 ssl http2;
  server_name  syncthing.filmer.nl;

  root /var/www/syncthing;

  allow  87.209.180.24;
  deny   all;

  # Letsencrypt certificates
  ssl_certificate /etc/letsencrypt/live/filmer.nl/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/filmer.nl/privkey.pem;


  location / {
    proxy_set_header        Host localhost;
    proxy_set_header        X-Real-IP $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;

    proxy_pass              http://127.0.0.1:8384/;

    proxy_read_timeout      600s;
    proxy_send_timeout      600s;
  }

  error_log /var/log/nginx/syncthing.filmer.nl.error.log error;
  access_log /var/log/nginx/syncthing.filmer.nl.log;

}
````

### Macbook

To start syncthing now and restart at login:

    brew services start syncthing

Or, if you don't want/need a background service you can just run:

    /usr/local/opt/syncthing/bin/syncthing -no-browser -no-restart

