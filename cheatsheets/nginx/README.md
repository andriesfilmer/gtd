## nginx install
    sudo apt-get install nginx

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

## Create a wildcard certificate

Get an [ACME Shell script](https://github.com/acmesh-official/acme.sh)

    curl https://get.acme.sh | sh # reload your shell so the alias `acme.sh` is available.

Use the automatic DNS API integration, for example: [Transip](https://github.com/acmesh-official/acme.sh/wiki/dnsapi2#dns_transip)

Create a key pair - [Transip](https://www.transip.nl/cp/account/api/) and **add your ipnr to the whitelist**

    # These varialbes are stored in `/root/.acme.sh/account.conf` after running acme.sh
    export TRANSIP_Username="your_username"
    export TRANSIP_Key_File="/path/to/transip-private.key"
    acme.sh --register-account -m my@example.com
    acme.sh --issue --dns dns_transip --dnssleep 100 -d domain.org -d *.domain.org

Add the next lines to you nginx `server` config

    # Letsencrypt certificates
    ssl_certificate /etc/letsencrypt/live/domain.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/domain.org/privkey.pem;

Install certificate (

    acme.sh --install-cert -d domain.org \
    --key-file /etc/letsencrypt/live/domain.org/privkey.pem \
    --fullchain-file /etc/letsencrypt/live/domain.org/fullchain.pem \
    --reloadcmd "service nginx force-reload"

Also put a [crontab](https://crontab.guru/) to renew the certificattes each month. For example:

    # Check if acme.sh has installed a crontab.
    0 0 * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null

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

copy [error-pages.conf](error-pages.conf) to `/etc/nginx/error-pages.conf`

Use the include in your `server` directive.

    include /etc/nginx/error-pages.conf;

Add a `location` directive for [error.html](error.html), see comments in `error-pages.conf`.

## Parse log files

    awk '{print $9}' access.log | sort | uniq -c | sort -rn

Details (error example 302)

    awk '($9 ~ /302/)' access.log | awk '{print $7}' | sort | uniq -c | sort -n

## Resources

* [acme.sh](https://github.com/acmesh-official/acme.sh) | Wildcard certs
* [How to optimize nginx configuration](https://www.digitalocean.com/community/tutorials/how-to-optimize-nginx-configuration)
* [Migrate from an Apache Web Server to Nginx](https://www.digitalocean.com/community/articles/how-to-migrate-from-an-apache-web-server-to-nginx-on-an-ubuntu-vps)
* [Setting Up PHP behind Nginx with FastCGI](http://www.sitepoint.com/setting-up-php-behind-nginx-with-fastcgi/)
* [Nginx Proxied to Unicorn](http://recipes.sinatrarb.com/p/deployment/nginx_proxied_to_unicorn)
* [Github and Unicorn](https://github.com/blog/517-unicorn)
* [Setting up Ubuntu with Nginx, Unicorn, ree, rvm](http://tomkersten.com/articles/nginx-unicorn-rvm-server-setup/)
* [.htaccess converter](http://winginx.com/en/htaccess)

