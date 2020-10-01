# Nextcloud

* [Nextcloud version 14 docs](https://docs.nextcloud.com/server/14/admin_manual/contents.html)

## Install

    apt install nextcloud

    apt install php7.4-fpm php7.4-curl php7.4-cli php7.4-mysql php7.4-gd php7.4-iconv php7.4-xsl php7.4-json php7.4-intl php-pear php-imagick php7.4-dev php7.4-common php7.4-mbstring php7.4-zip php7.4-soap -y

Check if php-sock is listening

    netstat -pl | grep php

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


### Onlyoffice

    sudo -u www-data php occ app:install documentserver_community
    sudo -u www-data php occ app:install onlyoffice

### Upgrade

    sudo -u www-data php occ upgrade -vv
