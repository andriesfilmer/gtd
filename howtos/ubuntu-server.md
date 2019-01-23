# First configurations for a Ubuntu server

## update

    apt-get update
    apt-get upgrade

## Fail2ban

    apt-get install fail2ban

Open /etc/fail2ban/jail.conf and add your own ip's:

    #          localhost   home-ip       server02        server03      server05
    ignoreip = 127.0.0.1/8 217.62.30.97  198.211.123.93  95.85.60.187  146.185.138.134

## Iptable rules

After the install off fail2ban save the current [iptables](https://wiki.debian.org/iptables) configuration.

    iptables-save > /etc/iptables.rules

Then add some custom rules before 'COMMIT' in '/etc/iptables.rules'

    # MySql/Mariadb
    -A INPUT -s 95.85.60.187 -i eth0 -p tcp -m tcp --dport 3306 -j ACCEPT
    -A INPUT -i eth0 -p tcp -m tcp --dport 3306 -j DROP

Reconfigure de firewall

    iptables-restore < /etc/iptables.rules

Create a file '/etc/network/if-pre-up.d/iptables' to make this permanent after reboot.

    #!/bin/sh
    /sbin/iptables-restore < /etc/iptables.rules

The file needs to be executable so change the permissions:

    chmod +x /etc/network/if-pre-up.d/iptables

### hosts.allow

[Allow ssh from dutch providers](http://nirsoft.net/countryip/nl.html) or [ip by country](https://www.ip2location.com/blockvisitorsbycountry.aspx)

These are **my** provider blocks

    # 81.204.0.0/14   KPN
    # 84.104.0.0/14   ZIGGO
    # 217.62.16.0/20  ZIGGO
    # 84.241.192.0/18 T-MOBILE
    #
    # 198.211.123.93  server02
    # 95.85.60.187    server03
    # 37.139.3.138    server04
    # 146.185.138.134 server05

    sshd: 81.204.0.0/14 84.104.0.0/14 217.62.16.0/20 84.241.192.0/18 217.62.30.97 198.211.123.93 95.85.60.187 37.139.3.138 146.185.138.134


### hosts.deny

And disable access from all others in `/etc/hosts.deny`

    sshd: ALL

## sudo

Add a new user (your self)

    adduser yourname
    usermod -aG sudo yourname

## .bashrc

I like to add these lines to `/root/.bashrc` first :-)

    bind '"\e[A"':history-search-backward
    bind '"\e[B"':history-search-forward

## Mail

    apt install postfix

Redirect root mails

    vi /etc/aliases

Add

    root: name@domain.nl

Update postfix

    newaliases
    service postfix restart

Test with the following command:

    echo test | mail -s "test message" root

## Timezone

    sudo dpkg-reconfigure tzdata

Crontab

    0 1 * * * /usr/bin/timedatectl

## Automatic Updates

    dpkg-reconfigure -plow unattended-upgrades

Or

To configure unattended-upgrades, edit `/etc/apt/apt.conf.d/50unattended-upgrades` and fit your needs:

To enable automatic updates, edit `/etc/apt/apt.conf.d/10periodic` and set the appropriate apt configuration options:

    APT::Periodic::Update-Package-Lists "1";
    APT::Periodic::Download-Upgradeable-Packages "1";
    APT::Periodic::AutocleanInterval "7";
    APT::Periodic::Unattended-Upgrade "1";

[Help.ubuntu.com - Automatic Updates](https://help.ubuntu.com/14.04/serverguide/automatic-updates.html)

## DigitalOcean

### Swap

On digitalocean the don't have swap files enabled on default

To creat as swap file of 1G

    fallocate -l 1G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile

Verify

    swapon -s
    free -m

Make the Swap File Permanent `/etc/fstab`

    /swapfile   none    swap    sw    0   0

Tunning

    echo 10 | tee /proc/sys/vm/swappiness
    echo vm.swappiness = 10 | tee -a /etc/sysctl.conf


## Alternative DNS servers

Edit `/etc/resolvconf/resolv.conf.d/base`

    # Google DNS servers Preferred/Alternate:
    nameserver 8.8.8.8
    nameserver 8.8.4.4

    # OpenDNS (preferred/alternate)
    nameserver 208.67.222.222
    nameserver 208.67.220.220

Then tell resolvconf to regenerate resolv.conf.

    resolvconf -u

## Running services

To find out all services that have been run at startup:

    systemctl list-units --type service

## Sysctl Tweaks

You can change the setting, see examples: cheatsheets/sysctl-example.md

Edit `/etc/sysctl.conf` and run following command to load changes to sysctl.

    sysctl -p

## Add file system full cronjob

You can make a crontab, when the file system is >80% full we'd like to receive a mail.

    0 9 * * * if [ "`df -l |grep '[8|9][0-9]\%'`" ]; then `df -h|/usr/bin/mail -s 'File system > 80\% full' root` ; fi


