# Nextcloud

* [Nextcloud version 14 docs](https://docs.nextcloud.com/server/14/admin_manual/contents.html)

## Install

    apt install nextcloud

    apt install php7.2-fpm php7.2-curl php7.2-cli php7.2-mysql php7.2-gd php7.2-iconv php7.2-xsl php7.2-json php7.2-intl php-pear php-imagick php7.2-dev php7.2-common php7.2-mbstring php7.2-zip php7.2-soap -y

Check if php-sock is listening

    netstat -pl | grep php

    apt install letsencrypt
    certbot certonly --standalone -d nextcloud.filmer.net

Download Nextcloud package from https://nextcloud.com/install/#instructions-server

    chown -R www-data:www-data /var/www/nextcloud/


## Configure Nginx Virtual Host for Nextcloud

Example on: /etc/nginx/sites-available/nextcloud

Include the configuration in nginx.

    ln -s /etc/nginx/sites-available/nextcloud /etc/nginx/sites-enabled/

Test configuration

    nginx -t

## config

    vi $HOME/.config/Nextcloud/nextcloud.cfg

Sync hidden files

    vi .config/Nextcloud/sync-exclude.lst

## occ

Rescan files

    cd /to/nextcloud_root_dir/
    sudo -u www-data php occ files:scan --all

Password

    sudo -u www-data php /var/www/nextcloud/occ user:resetpassword andries

### Passwords

    sudo -u www-data php occ passwords:backup:restore 2019-01-18_15-56-11

