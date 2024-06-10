## nginx install
    sudo apt-get install nginx

## nginx config

Example [nginx.conf](./nginx.conf)


## fastcgi php

    apt install php-fpm

## Deny access

    # Under location
    deny all;
    allow 84.106.246.124;

## Prevent (deny) Access to Hidden Files

    location ~ /\. {
       access_log off;
       log_not_found off;
       deny all;
    }

## Letsencrypt certificates

    apt install letsencrypt
    apt install python3-certbot-nginx


## nginx config

    server {
      listen 80;
      server_name subdomain.domain;

      # enforce https
      return 301 https://$server_name$request_uri;

      location ^~ /.well-known/ {
        default_type "text/plain";
        allow all;
        auth_basic off;
        # Shared letsencrypt root dir (.well-known/acme-challenge)
        root /var/www/letsencrypt/;
      }

      error_log /var/log/nginx/letsencrypt.log error;
      access_log /var/log/nginx/letsencrypt.log;

    }

Create a certificate

    certbot certonly --webroot -w /var/www/letsencrypt/ -d subdomain.domain

To renew the certificates

    certbot renew --dry-run

Revoke the certificates

    certbot revoke --cert-path /etc/letsencrypt/live/subdomain.domain.nl-0001/fullchain.pem

<https://certbot.eff.org/docs/using.html#nginx>

Testing: <https://www.ssllabs.com/ssltest/analyze.html?d=subdomain.domain.nl>

Add this to the crontab (run every first day of month at 4:30pm)

    30 4 1 * * /usr/bin/certbot -q renew

### Wildcard domain

    /usr/bin/certbot certonly --nignx --preferred-challenges=dns --email andries@filmer.nl --server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d filmer.nl -d "*.filmer.nl"
    /usr/bin/certbot renew --cert-name filmer.nl --manual --preferred-challenges dns

Then deploy two times a DNS TXT record `acme-challenge` by following the instructions.

Add the next lines to you nginx `server` config

    ssl_certificate /etc/letsencrypt/live/filmer.nl/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/filmer.nl/privkey.pem;

Also put a crontab to renew the certificattes each month. For example:

    15 4 1 * * /usr/bin/certbot renew

### Install other certificates

Combine all the certificates into a single file. For Nginx it is required to have all the certificates (one for your domain name and CA ones) combined in a single file. The certificate for your domain should be listed first in the file, followed by the chain of CA certificates.

To combine the certificates in case of PositiveSSL, run the following command in terminal:

    cat certificate.crt <(echo) cabundle.crt > yourdomain-certificate.crt

Check that begin certificat start on new line. Not:

    -----END CERTIFICATE----------BEGIN CERTIFICATE-----

But:

    -----END CERTIFICATE-----
    -----BEGIN CERTIFICATE-----

In your nginx config:

    ssl_certificate /etc/ssl/yourdomain-certificate.crt;
    ssl_certificate_key /etc/ssl/private/yourdomain-certificate.key; # i.o. certificate.key

## Custom error page

copy <error-pages.conf> map to `/etc/nginx/error-pages.conf`

Use the include in your `server` directive.

    include /etc/nginx/error-pages.conf;

Add a `location` directive for <error.html>, see comments in `error-pages.conf`.

## Dynamic SSI Example

For example incluce headers, menu of footers.

<https://www.nginx.com/resources/wiki/start/topics/examples/dynamic_ssi/>

## PageSpeed Module

<cheatsheets/nginx/ngx_pagespeed.md>


## Parse log files

    awk '{print $9}' access.log | sort | uniq -c | sort -rn

Details (error example 302)

    awk '($9 ~ /302/)' access.log | awk '{print $7}' | sort | uniq -c | sort -n

## Resources

* [How to optimize nginx configuration](https://www.digitalocean.com/community/tutorials/how-to-optimize-nginx-configuration)
* [Migrate from an Apache Web Server to Nginx](https://www.digitalocean.com/community/articles/how-to-migrate-from-an-apache-web-server-to-nginx-on-an-ubuntu-vps)
* [Setting Up PHP behind Nginx with FastCGI](http://www.sitepoint.com/setting-up-php-behind-nginx-with-fastcgi/)
* [Nginx Proxied to Unicorn](http://recipes.sinatrarb.com/p/deployment/nginx_proxied_to_unicorn)
* [Github and Unicorn](https://github.com/blog/517-unicorn)
* [Setting up Ubuntu with Nginx, Unicorn, ree, rvm](http://tomkersten.com/articles/nginx-unicorn-rvm-server-setup/)
* [.htaccess converter](http://winginx.com/en/htaccess)


