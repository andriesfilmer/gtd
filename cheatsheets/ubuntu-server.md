# First configurations for a Ubuntu server

## Add vim

    apt install vim

## Fail2ban

    apt install fail2ban

`vi /etc/fail2ban/jail.local` and add your own ip's to jail.local:

````
[DEFAULT]
#          localhost   home-ip        server01        server02       server04        server08
ignoreip = 127.0.0.1/8 87.209.180.24  178.128.254.144 159.223.11.178 146.190.236.166 159.65.199.31
````

Checkstatus

    systemctl status fail2ban
    fail2ban-client status sshd

## hosts.allow

* [CIDR blocks for Ziggo (ipinfo.io)](https://ipinfo.io/AS33915)
* [ip by country](https://www.ip2location.com/blockvisitorsbycountry.aspx)
* [Allow ssh from dutch providers](http://nirsoft.net/countryip/nl.html)

content hosts.allow

````
# CIDR ranges with ssh access
#------------------------------
# 81.204.0.0/14    KPN
# 84.104.0.0/14    VODAFONE_ZIGGO
# 217.62.16.0/20   ZIGGO-CM
# 94.211.144.0/21  ZIGGO-CM
# 212.204.160.0/19 ZIGGO-CM
# 84.241.192.0/19  Odido Netherlands
# 87.210.0.0/16    Odido WBA Services
#-------------------------------
# 178.128.254.144 server01
# 159.223.11.178  server02
# 95.85.60.187    server03
# 146.190.236.166 server04
# 159.65.199.31   server08
# 87.209.180.24   Home - Glas
#-------------------------------

sshd: 81.204.0.0/14 84.104.0.0/14 217.62.16.0/20 94.211.144.0/21 212.204.160.0/19 84.241.192.0/19 178.128.254.144 146.190.236.166 159.65.199.31 87.209.180.24
````
## hosts.deny

And disable access from all others in `/etc/hosts.deny`

    sshd: ALL

## Configure [iptables](https://help.ubuntu.com/community/IptablesHowTo)

Install `iptables-persistent` to make iptables rules permanent after reboot.

    apt install iptables-persistent

Check if it is running

    systemctl status netfilter-persistent.service

Add some custom rules before `COMMIT` in `/etc/iptables/rules.v4`

````
*filter
# MySql/Mariadb
-A INPUT -s 95.85.60.187 -i eth0 -p tcp -m tcp --dport 3306 -j ACCEPT
-A INPUT -i eth0 -p tcp -m tcp --dport 3306 -j DROP
# Mail
-A INPUT -i eth0 -p tcp -m tcp --dport 25 -j DROP
COMMIT
````

Enable new rules

    systemctl restart netfilter-persistent.service

Or without disconnected from current ssh login

    iptables-restore < /etc/iptables/rules.v4

Or enable new rules with fontend [ufw](https://help.ubuntu.com/community/UFW) for iptables and `iptables-save`

## update

    apt update
    apt upgrade

    update-alternatives --config editor

## sshd no root login

change `vi /etc/ssh/sshd_config`

    PermitRootLogin no

## Add a new user (your self)

    adduser yourname
    usermod -aG sudo yourname

## .bashrc

I like to add these lines to `/root/.bashrc` first :-)

    bind '"\e[A"':history-search-backward
    bind '"\e[B"':history-search-forward

## Mail

    apt install postfix
    apt install mailutils

Configure as smarthost for delivering mail via mailserver

Reconfigure postfix?

    dpkg-reconfigure postfix

Redirect root mails

    vi /etc/aliases

Add

    root: name@domain.nl

Update postfix

    newaliases
    systemctl restart postfix

Test with the following command:

    echo test | mail -s "test message" root



### Journal

Set max file size `vi /etc/systemd/journald.conf`

    SystemMaxFileSize=2G

## Timezone

    dpkg-reconfigure tzdata

## Automatic Updates

    dpkg-reconfigure -plow unattended-upgrades

Configure unattended-upgrades, edit `/etc/apt/apt.conf.d/50unattended-upgrades` and fit your needs:

* `${distro_id}:${distro_codename}-updates;`
* `Unattended-Upgrade::Mail "mail@domain;`
* `Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";`
* `Unattended-Upgrade::Remove-New-Unused-Dependencies "true";`
* `Unattended-Upgrade::Automatic-Reboot "true";`
* `Unattended-Upgrade::Automatic-Reboot-Time "07:00"`;

## DigitalOcean

### Swap

On digitalocean they don't have swap files enabled on default

To creat as swap file of 1G

    fallocate -l 1G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile

Verify

    swapon -s
    free -m

Make the Swap File Permanent

    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

Tunning

    echo vm.swappiness = 10 | tee -a /etc/sysctl.conf
    echo vm.vfs_cache_pressure = 50 | tee -a /etc/sysctl.conf

More info: <https://www.digitalocean.com/community/tutorials/how-to-add-swap-space-on-ubuntu-22-04>

## Add cronjobs

You can make a crontab, when the file system is >80% full we'd like to receive a mail.

    0 9 * * * if [ "`df -l |grep '[8|9][0-9]\%'`" ]; then `df -h|/usr/bin/mail -s 'File system > 80\% full' root` ; fi

Cleanup journal logfile upto 2G

    2 2 2 * * /usr/bin/journalctl --vacuum-size=2G

## Running services

To find out all services that have been run at startup:

    systemctl --state=running
    systemctl list-units --type service

## Sysctl Tweaks

You can change the setting, see examples: `cheatsheets/sysctl-example.md`

Edit `/etc/sysctl.conf` and run following command to load changes to sysctl.

    sysctl -p

## AIDE (Advanced Intrusion Detection Environment)

    apt install aide

    cp /var/lib/aide/aide.conf.autogenerated /etc/aide.conf # Old?
    cp /usr/share/aide/config/aide/aide.conf /etc/aide/aide.conf # New?

Change the rules configuration `/etc/aide/aide.conf`.

    # Exclude directories
    !/lib/
    !/var/
    !/proc/
    !/dev/

After making configuration changes.

    update-aide.conf

Run for new (first) db

    aideinit -y -f

Copy db

    cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
    touch /bin/date # to check integritry
    aide -c /etc/aide/aide.conf --check
    aide -c /etc/aide/aide.conf --update

Change the general configuration `/etc/default/aide`

    MAILTO=yourname@domain.nl
    QUIETREPORTS=yes
    COMMAND=update
    COPYNEWDB=yes

AIDE sets up itself a daily execution script `/etc/cron.daily/aide`

### please-dont-call-aide-without-parameters error.

    touch /var/lib/aide/aide.db
    chmod 755 /var/lib/aide/aide.db
    aide --config=/usr/share/aide/config/aide/aide.conf --check
