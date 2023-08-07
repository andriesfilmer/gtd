# Racicale - CalDav & CardDav server

Run the following command as root or add the --user argument to only install for the current user

    python3 -m pip install --upgrade radicale
    python3 -m radicale --config "" --storage-filesystem-folder=~/.var/lib/radicale/collections

Victory! Open http://localhost:5232/ in your browser! You can login with any username and password.

## Nginx config

    server {
      listen 80;
      listen [::]:80;
      server_name dav.filmer.net;

      # enforce https
      return 301 https://$server_name$request_uri?;
    }

    server {
      listen 443 ssl http2;
      listen [::]:443 ssl http2;
      server_name dav.filmer.nl;
      ssl_certificate /etc/letsencrypt/live/dav.filmer.nl/fullchain.pem;
      ssl_certificate_key /etc/letsencrypt/live/dav.filmer.nl/privkey.pem;

      location / { # The trailing / is important!
        proxy_pass           http://localhost:5232/; # The / is important!
        proxy_set_header     X-Script-Name /;
        proxy_set_header     X-Forwarded-For $proxy_add_x_forwarded_for;
        #proxy_pass_header Authorization;
        auth_basic           "Radicale - Password Required";
        auth_basic_user_file /etc/nginx/htpasswd;
      }

      error_log /var/log/nginx/dav.filmer.nl.error.log error;
      access_log /var/log/nginx/dav.filmer.nl.log;

    }


## Macbook config

![Radicale-CardDav-Apple-Config](https://nextcloud.filmer.nl/data/andries/files/Public/github/gtd/Radicale-CardDav-Apple.png)


## Resources

* <https://radicale.org/>
* [vCard properties](https://www.iana.org/assignments/vcard-elements/vcard-elements.xhtml)
* [iCalendar properties](https://www.iana.org/assignments/icalendar/icalendar.xhtml)

