# Radicale - CalDav & CardDav server

   To install Radicale system-wide

    apt install radicale

Using a Virtual Environment read cheatsheet [python](python.md)

Run the following command as root or add the --user argument to only install for the current user

    python3 -m pip install --upgrade radicale
    python3 -m radicale --storage-filesystem-folder=~/.var/lib/radicale/collections

## Security

Create the radicale user and group for the Radicale service

    useradd --system --user-group --home-dir / --shell /sbin/nologin radicale

The storage folder must be writable by radicale.

    mkdir -p /var/lib/radicale/collections && chown -R radicale:radicale /var/lib/radicale/collections

The storage should not be readable by others.

    chmod -R o= /var/lib/radicale/collections

## Running as a service

Create the file `/etc/systemd/system/radicale.service`

````
[Unit]
Description=A simple CalDAV (calendar) and CardDAV (contact) server
After=network.target
Requires=network.target

[Service]
ExecStart=/usr/bin/env python3 -m radicale
Restart=on-failure
User=radicale
# Deny other users access to the calendar data
UMask=0027
# Optional security settings
PrivateTmp=true
ProtectSystem=strict
ProtectHome=true
PrivateDevices=true
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
NoNewPrivileges=true
ReadWritePaths=/var/lib/radicale/collections

[Install]
WantedBy=multi-user.target
````

Enable the service

    systemctl enable radicale
    systemctl start radicale
    systemctl status radicale

## Nginx config

    server {
      listen 80;
      listen [::]:80;
      server_name dav.filmer.nl;

      # enforce https
      return 301 https://$server_name$request_uri?;
    }

    server {
      listen 443 ssl http2;
      listen [::]:443 ssl http2;
      server_name dav.filmer.nl;
      ssl_certificate /etc/letsencrypt/live/filmer.nl/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/filmer.nl/privkey.pem;

      location / { # The trailing / is important!
        proxy_pass           http://localhost:5232/; # The / is important!
        proxy_set_header     X-Script-Name /;
        proxy_set_header     X-Forwarded-For $proxy_add_x_forwarded_for;
        #proxy_pass_header Authorization;
        auth_basic           "Radicale - Password Required";
        auth_basic_user_file /etc/nginx/.htpasswd; # Create a password with htpasswd
      }

      error_log /var/log/nginx/dav.filmer.nl.error.log error;
      access_log /var/log/nginx/dav.filmer.nl.log;

    }

### htpasswd

    apt install apache2-utils

Create additional user-password pairs. Omit the -c flag because the file already exists

    htpasswd -c /etc/nginx/.htpasswd user1

## Macbook config

![Radicale-CardDav-Apple-Config](https://nextcloud.filmer.nl/data/andries/files/Public/github/gtd/Radicale-CardDav-Apple.png)


## Resources

* <https://radicale.org/>
* [vCard properties](https://www.iana.org/assignments/vcard-elements/vcard-elements.xhtml)
* [iCalendar properties](https://www.iana.org/assignments/icalendar/icalendar.xhtml)

