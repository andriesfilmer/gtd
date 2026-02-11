# First configurations for a Ubuntu server

## update

    apt update
    apt upgrade

## Add vim

    apt install vim

## Fail2ban

    apt install fail2ban

`vi /etc/fail2ban/jail.local` and add your own ip's to jail.local:

````
[DEFAULT]
#          localhost   home-ip        server01        server02       server04        server05        server06       server07      server08
ignoreip = 127.0.0.1/8 87.209.180.24  178.128.254.144 159.223.11.178 146.190.236.166 146.185.159.154 46.224.216.201 159.69.245.21 88.198.199.37

banaction = iptables

[sshd]
enabled=true
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
# 81.204.0.0/14     KPN
# 62.166.128.0/17   Odido Netherlands
# 84.241.192.0/19   Odido Netherlands
# 87.210.0.0/16     Odido WBA Services
# 87.209.180.24     Home - Glas
# 62.166.166.129    Home - Glas 2025-01-15
#-------------------------------
# 178.128.254.144   server01
# 159.223.11.178    server02
# 91.99.94.83       server03
# 146.190.236.166   server04
# 146.185.159.154   server05
# 46.224.216.201    server06
# 159.69.245.21     server07
# 88.198.199.37     server08
#-------------------------------
# Add some Proton vpn profile addresses
#-------------------------------

sshd: 81.204.0.0/14 62.166.128.0/17 84.241.192.0/19 87.210.0.0/16 87.209.180.24 62.166.166.129 \
      178.128.254.144 159.223.11.178 91.99.94.83 146.190.236.166 146.185.159.154 46.224.216.201 159.69.245.21 88.198.199.37\
      138.199.7.0/24 138.199.7.0/24 146.70.86.0/24 77.247.178.0/24

````
## hosts.deny

And disable access from all others in `/etc/hosts.deny`

    sshd: ALL

## .bashrc

I like to add these lines to `/root/.bashrc` now :-)

    bind '"\e[A"':history-search-backward
    bind '"\e[B"':history-search-forward

## Configure [iptables](https://help.ubuntu.com/community/IptablesHowTo)

Install `iptables-persistent` to make iptables rules permanent after reboot.

    apt install iptables-persistent

Check if it is running

    systemctl status netfilter-persistent.service

Add some custom ip4 rules before `COMMIT` in `/etc/iptables/rules.v4`

````
*filter
# MySql/Mariadb
-A INPUT -s server07.igroupware.org -i eth0 -p tcp -m tcp --dport 3306 -j ACCEPT
-A INPUT -i eth0 -p tcp -m tcp --dport 3306 -j DROP
# Mail
-A INPUT -i eth0 -p tcp -m tcp --dport 25 -j DROP
COMMIT
````

Add some custom ip6 rules before `COMMIT` in `/etc/iptables/rules.v6`
Or better via sysctl, see below.

````
*filter
-I INPUT -i eth0 -j REJECT
-I OUTPUT -o eth0 -j REJECT
-I FORWARD -j REJECT
COMMIT
````

Enable new rules

    systemctl restart netfilter-persistent.service

Or without disconnected from current ssh login

    iptables-restore < /etc/iptables/rules.v4
    ip6tables-restore < /etc/iptables/rules.v6

Or enable new rules with fontend [ufw](https://help.ubuntu.com/community/UFW) for iptables and `iptables-save`

## Add a new user (your self)

    adduser andries
    usermod -aG sudo andries

## sshd no root login

change `vi /etc/ssh/sshd_config`

    PermitRootLogin no

## Mail

    apt install postfix mailutils

Configure postfix as `smarthost` for delivering mail via mailserver

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

Configure unattended-upgrades, edit and fit your needs:

    vi /etc/apt/apt.conf.d/50unattended-upgrades

* `${distro_id}:${distro_codename}-updates;`
* `Unattended-Upgrade::Mail "mail@domain;`
* `Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";`
* `Unattended-Upgrade::Remove-New-Unused-Dependencies "true";`
* `Unattended-Upgrade::Automatic-Reboot "true";`
* `Unattended-Upgrade::Automatic-Reboot-Time "07:00"`;

## Swap

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

## ssh banner

     vi /etc/ssh/welcome.txt

Add text to show what server you are logged into. Use Figlet for some asciiart ;-)

    figlet outgoing mailserver

Edit `/etc/ssh/sshd_config` and enable the banner.

    Banner /etc/ssh/welcome.txt

## Running services

To find out all services that have been run at startup:

    systemctl --state=running
    systemctl list-units --type service

## Sysctl Tweaks

You can change the setting, see examples: `cheatsheets/sysctl-example.md`

````
# Disable IPv6 at all, disable it at the system level
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
````

Edit `/etc/sysctl.conf` and run following command to load changes to sysctl.

    sysctl -p

