## nginx install
    sudo apt-get install nginx

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

## Nginx and Unicorn

[Unicorn](http://unicorn.bogomips.org/)

CD to your Rails application. Add  'gem 'unicorn' to you Gemfile and run:

    bundle install
    bundle install --binstubs # This will generate a relative 'bin' directory to use in our init.sh

Create a '[APP_ROOT/config/unicorn.conf.rb](../inzetrooster-app/blob/master/config/unicorn.conf.rb)' config file.

Create a '[APP_ROOT/config/nginx.conf](../inzetrooster-app/blob/master/config/nginx.conf)' config file.

    service nginx restart

Start Unicorn or create a '[/etc/init.d/some_app](../inzetrooster-app/blob/master/config/unicorn.init.sh)' init script.

    unicorn -c path/to/unicorn.rb -E development -D

Stop Unicorn or use the init script
    cat /path/to/app/tmp/pids/unicorn.pid | xargs kill -QUIT

Use a init script if you want to start on reboot
    ln -s /var/www/APP_ROOT/config/[unicorn.init.sh](/pub/scripts/rails/unicorn.init.sh) /etc/init.d/unicorn_APP_NAME.nl
    update-rc.d some-app defaults

## Converting rewrite rules from apache

[Converting rewrite rules](http://nginx.org/en/docs/http/converting_rewrite_rules.html)

## Multiple HTTPS/TLS/ SSL sites

You can make sure that SNI is enabled on your server:

    nginx -V | grep SNI

After displaying the nginx version, you should see the line:

    TLS SNI support enabled

**Purchase a certificate by a CA**

With Comodo you have to merge your certificates
    cat yourdomain.crt ca-bundle.crt > ssl-yourdomain-ca-bundle.crt

A example ngix config:

    server {

           listen   443;
           server_name example.com;

           root /usr/share/nginx/www;
           index index.html index.htm;

           ssl on;
           ssl_certificate /etc/nginx/ssl/yourdomain-certificate-bundle.crt;
           ssl_certificate_key /etc/nginx/ssl/private/yourdomain-server.key;
    }

More info:
* [Configuring https servers](http://nginx.org/en/docs/http/configuring_https_servers.html)
* [How To Set Up Multiple SSL Certificates on One IP with Nginx on Ubuntu 12.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-multiple-ssl-certificates-on-one-ip-with-nginx-on-ubuntu-12-04)

## Address already in use

If you get following error, when you try to start nginx

    [emerg]: bind() to 0.0.0.0:80 failed (98: Address already in use)

Then it means nginx or some other process is already using port 80.

You can kill it using:

    sudo fuser -k 80/tcp

And then try restarting nginx again:

    service nginx start

## Letsencrypt
Create a certificate

    root@server04:~/letsencrypt# ./certbot-auto --nginx -m itc@domain.nl -d subdomain.domain.nl

To renew the certificates

    ./certbot-auto renew --dry-run

Revoke the certificates

    root@server04:~/letsencrypt# ./certbot-auto revoke --cert-path /etc/letsencrypt/live/subdomain.domain.nl-0001/fullchain.pem

<https://certbot.eff.org/docs/using.html#nginx>

Testing: <https://www.ssllabs.com/ssltest/analyze.html?d=subdomain.domain.nl>

### Renew Letsencrypt

    /root/letsencrypt/letsencrypt-auto

## Install certificates
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

## PageSpeed Module
[Build ngx_pagespeed local from source](https://modpagespeed.com/doc/build_ngx_pagespeed_from_source) and created a DEB package.

    scp nginx_1.10.3-1~xenial_amd64.deb server02:/home/andries/
    cp -rp /etc/nginx /home/andries/
    apt purge nginx nginx-common
    dpkg -i /home/andries/nginx_1.10.3-1~xenial_amd64.deb
    mv /home/andries/nginx/ /etc/nginx

To prevent your custom Nginx package from being replaced in the future I **Pinned** the version.

    sudo vi /etc/apt/preferences.d/nginx

* [How To Add ngx_pagespeed to Nginx on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-add-ngx_pagespeed-to-nginx-on-ubuntu-14-04)
* [Configuring PageSpeed Filters](https://www.modpagespeed.com/doc/config_filters)

## Resources
* [Migrate from an Apache Web Server to Nginx](https://www.digitalocean.com/community/articles/how-to-migrate-from-an-apache-web-server-to-nginx-on-an-ubuntu-vps)
* [Setting Up PHP behind Nginx with FastCGI](http://www.sitepoint.com/setting-up-php-behind-nginx-with-fastcgi/)
* [Nginx Proxied to Unicorn](http://recipes.sinatrarb.com/p/deployment/nginx_proxied_to_unicorn)
* [Github and Unicorn](https://github.com/blog/517-unicorn)
* [Setting up Ubuntu with Nginx, Unicorn, ree, rvm](http://tomkersten.com/articles/nginx-unicorn-rvm-server-setup/)
* [.htaccess converter](http://winginx.com/en/htaccess)


