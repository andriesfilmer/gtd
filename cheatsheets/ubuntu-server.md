# First configurations for a Ubuntu server

## update

    apt-get update
    apt-get upgrade

    update-alternatives --config editor

## Fail2ban

    apt install fail2ban

`cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local` and add your own ip's to jail.local:

    #          localhost   home-ip        server01        server03     server05        server06       server08
    ignoreip = 127.0.0.1/8 94.211.146.214 178.128.254.144 95.85.60.187 206.189.108.222 198.199.127.67 159.65.199.31

Checkstatus

    systemctl status fail2ban
    fail2ban-client status sshd

Check iptables with fail2ban-client

    fail2ban-client set sshd unbanip 23.34.45.56

## bugfix ubuntu 24.04 (fail2ban No module named 'asynchat')

    apt install python3-pip
    python3 -m pip install pyasynchat --break-system-packages
    systemctl start fail2ban

## hosts.allow

* [CIDR blocks for Ziggo (ipinfo.io)](https://ipinfo.io/AS33915)
* [ip by country](https://www.ip2location.com/blockvisitorsbycountry.aspx)
* [Allow ssh from dutch providers](http://nirsoft.net/countryip/nl.html)

content hosts.allow

    # CIDR ranges with ssh access
    # -----------------------------
    # 81.204.0.0/14    KPN
    # 84.104.0.0/14    ZIGGO
    # 217.62.16.0/20   ZIGGO
    # 94.211.144.0/21  ZIGGO
    # 212.204.160.0/19 ZIGGO
    # 84.241.192.0/18  T-MOBILE
    # ------------------------------
    # 178.128.254.144 server01
    # 95.85.60.187    server03
    # 206.189.108.222 server05
    # 198.199.127.67  server06
    # 159.65.199.31   server08
    # ------------------------------

    sshd: 81.204.0.0/14 84.104.0.0/14 217.62.16.0/20 94.211.144.0/21 212.204.160.0/19 84.241.192.0/18 178.128.254.144 95.85.60.187 206.189.108.222 198.199.127.67 159.65.199.31


## hosts.deny

And disable access from all others in `/etc/hosts.deny`

    sshd: ALL

## Configure [iptables](https://help.ubuntu.com/community/IptablesHowTo)

Install `iptables-persistent` to make iptables rules permanent after reboot.

    apt install iptables-persistent

Check if it is running

    systemctl status netfilter-persistent.service

Add some custom rules before `COMMIT` in `/etc/iptables/rules.v4`

    # MySql/Mariadb
    -A INPUT -s 95.85.60.187 -i eth0 -p tcp -m tcp --dport 3306 -j ACCEPT
    -A INPUT -i eth0 -p tcp -m tcp --dport 3306 -j DROP
    # Mail
    -A INPUT -i eth0 -p tcp -m tcp --dport 25 -j DROP


Enable new rules

    systemctl restart netfilter-persistent.service

Or without disconnected from current ssh login

    iptables-restore < /etc/iptables/rules.v4

Or enable new rules with fontend [ufw](https://help.ubuntu.com/community/UFW) for iptables and `iptables-save`

## Add a new user (your self)

    adduser yourname

## .bashrc

I like to add these lines to `/root/.bashrc` first :-)

    bind '"\e[A"':history-search-backward
    bind '"\e[B"':history-search-forward

## Mail

    apt install postfix

Configure as smarthost for delivering mail via mailserver

Reconfigure postfix?

    dpkg-reconfigure postfix

Redirect root mails

    vi /etc/aliases

Add

    root: name@domain.nl

Update postfix

    newaliases
    service postfix restart

Test with the following command:

    echo test | mail -s "test message" root


## Syslog

Set log preferences `vi /etc/rsyslog.d/50-default.conf`

The next line means log every facility at every level to /var/log/syslog, with authpriv being the only exception.
Obviously this includes mail, so #comment/disable this line. Adjust some other preferences.

    #*.*;auth,authpriv.none         -/var/log/syslog
    cron.*                          /var/log/cron.log
    daemon.*                        -/var/log/daemon.log
    kern.*                          -/var/log/kern.log
    #lpr.*                          -/var/log/lpr.log
    mail.*                          -/var/log/mail.log
    user.*                          -/var/log/user.log

Set log rotate mail daily instead of weekly.

    vi /etc/logrotate.d/rsyslog

    /var/log/mail.info
    /var/log/mail.warn
    /var/log/mail.err
    /var/log/mail.log
    {
            daily
    }

### Journal

Set max file size `vi /etc/systemd/journald.conf`

    SystemMaxFileSize=2G

## Timezone

    dpkg-reconfigure tzdata

## Automatic Updates

Create a `/etc/apt/apt.conf.d/20auto-upgrades` file with:

    dpkg-reconfigure -plow unattended-upgrades

Looks like

    APT::Periodic::Update-Package-Lists "1";
    APT::Periodic::Unattended-Upgrade "1";
    APT::Periodic::AutocleanInterval "7";

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

Make the Swap File Permanent `/etc/fstab`

    /swapfile   none    swap    sw    0   0

Tunning

    echo 10 | tee /proc/sys/vm/swappiness
    echo vm.swappiness = 10 | tee -a /etc/sysctl.conf

## Running services

To find out all services that have been run at startup:

    systemctl --state=running
    systemctl list-units --type service

## Sysctl Tweaks

You can change the setting, see examples: cheatsheets/sysctl-example.md

Edit `/etc/sysctl.conf` and run following command to load changes to sysctl.

    sysctl -p

## Add cronjobs

You can make a crontab, when the file system is >80% full we'd like to receive a mail.

    0 9 * * * if [ "`df -l |grep '[8|9][0-9]\%'`" ]; then `df -h|/usr/bin/mail -s 'File system > 80\% full' root` ; fi

Cleanup journal logfile upto 2G

    2 2 2 * * /usr/bin/journalctl --vacuum-size=2G

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
