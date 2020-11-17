## nginx install
    sudo apt-get install nginx

## nginx config

`vi /etc/nginx/nginx.conf`

Global setting:

    # Check our core’s limitations by issuing a ulimit command:
    # `ulimit -n` -> 1024
    worker_connections 1024;  # worker_connections 768

    keepalive_timeout 15s;     # keepalive_timeout 75s
    client_body_timeout 12s;   # client_body_timeout 60s
    client_header_timeout 12s; # client_header_timeout 60s
    send_timeout 10s;          # send_timeout 60s
    types_hash_max_size 2048;  # default 1024
    server_tokens off;         # default (nginx/1.18.0 (Ubuntu)
    client_max_body_size 10m;  # default 1m

Enable gzip:

    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_disable "msie6";
    gzip_min_length 256;
    gzip_disable "msie6";

Expires map:

  map $sent_http_content_type $expires {
    default                    off;
    text/html                  epoch;
    text/css                   1w;
    application/javascript     1w;
    ~image/                    1w;
  }

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

Create a certificate

    certbot certonly --webroot -w /var/www/subdomain.domain.nl/letsencrypt/ -d subdomain.domain.nl

To renew the certificates

    certbot renew --dry-run

Revoke the certificates

    certbot revoke --cert-path /etc/letsencrypt/live/subdomain.domain.nl-0001/fullchain.pem

<https://certbot.eff.org/docs/using.html#nginx>

Testing: <https://www.ssllabs.com/ssltest/analyze.html?d=subdomain.domain.nl>

Add this to the crontab (run every first day of month at 4:30pm)

    30 4 1 * * /usr/bin/certbot -q renew

### Install other certificates

Combine all the certificates into a single file. For Nginx it is required to have all the certificates (one for your domain name and CA ones) combined in a single file. The certificate for your domain should be listed first in the file, followed by the chain of CA certificates.

To combine the certificates in case of PositiveSSL, run the following command in terminal:

    cat certificate.crt cabundle.crt > yourdomain-certificate.crt

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

[Build ngx_pagespeed local from source](https://modpagespeed.com/doc/build_ngx_pagespeed_from_source) and created a DEB package and `scp` to server.

    scp nginx_1.10.3-1~xenial_amd64.deb server02:/home/andries/
    cp -rp /etc/nginx /home/andries/
    apt purge nginx nginx-common
    dpkg -i /home/andries/nginx_1.10.3-1~xenial_amd64.deb
    mv /home/andries/nginx/ /etc/nginx

To prevent your custom Nginx package from being replaced in the future I **Pinned** the version.

    sudo vi /etc/apt/preferences.d/nginx

    Package: nginx
    Pin: version 1.10.3-1~xenial
    Pin-Priority: 1001

* [How To Add ngx_pagespeed to Nginx on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-add-ngx_pagespeed-to-nginx-on-ubuntu-14-04)
* [Configuring PageSpeed Filters](https://www.modpagespeed.com/doc/config_filters)

## Resources

* [How to optimize nginx configuration](https://www.digitalocean.com/community/tutorials/how-to-optimize-nginx-configuration)
* [Migrate from an Apache Web Server to Nginx](https://www.digitalocean.com/community/articles/how-to-migrate-from-an-apache-web-server-to-nginx-on-an-ubuntu-vps)
* [Setting Up PHP behind Nginx with FastCGI](http://www.sitepoint.com/setting-up-php-behind-nginx-with-fastcgi/)
* [Nginx Proxied to Unicorn](http://recipes.sinatrarb.com/p/deployment/nginx_proxied_to_unicorn)
* [Github and Unicorn](https://github.com/blog/517-unicorn)
* [Setting up Ubuntu with Nginx, Unicorn, ree, rvm](http://tomkersten.com/articles/nginx-unicorn-rvm-server-setup/)
* [.htaccess converter](http://winginx.com/en/htaccess)


