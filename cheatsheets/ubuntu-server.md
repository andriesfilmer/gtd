# First configurations for a Ubuntu server

## update

    apt-get update
    apt-get upgrade

    update-alternatives --config editor

## Fail2ban

    apt install fail2ban

copy /etc/fail2ban/jail.conf /etc/fail2ban/jail.local and add your own ip's to jail.local:

    #          localhost   home-ip      server02       server03     server05        server06
    ignoreip = 127.0.0.1/8 94.211.146.214 198.211.123.93 95.85.60.187 146.185.138.134 198.199.127.67

Checkstatus

    systemctl status fail2ban
    fail2ban-client status sshd

Check iptables with fail2ban-client

    fail2ban-client set sshd unbanip 23.34.45.56


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

Or enable new rules with fontend [ufw](https://help.ubuntu.com/community/UFW] for iptables and `iptables-save`

## hosts.allow

[Allow ssh from dutch providers](http://nirsoft.net/countryip/nl.html) or [ip by country](https://www.ip2location.com/blockvisitorsbycountry.aspx)

These are **my** provider blocks

    # 81.204.0.0/14   KPN
    # 84.104.0.0/14   ZIGGO
    # 217.62.16.0/20  ZIGGO
    # 94.211.144.0/21 ZIGGO
    # 84.241.192.0/18 T-MOBILE
    #
    # 198.211.123.93  server02
    # 95.85.60.187    server03
    # 37.139.3.138    server04
    # 146.185.138.134 server05
    # 198.199.127.67  server06
    # 37.139.14.57    server07

    sshd: 81.204.0.0/14 84.104.0.0/14 217.62.16.0/20 94.211.144.0/21 84.241.192.0/18 94.211.146.214 198.211.123.93 95.85.60.187 37.139.3.138 146.185.138.134 198.199.127.67 37.139.14.57

## hosts.deny

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

    *.*;auth,authpriv.none          -/var/log/syslog

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

* Enable updates: `"${distro_id}:${distro_codename}-updates";`
* Setup email alert: `Unattended-Upgrade::Mail "mail@domain";i`
* Reboot WITHOUT CONFORMATION: `Unattended-Upgrade::Automatic-Reboot "true";`
* Reboot time: `Unattended-Upgrade::Automatic-Reboot-Time "02:00"`;

Check logfiles

    tail /var/log/unattended-upgrades/unattended-upgrades*.log

Resource: <https://www.cyberciti.biz/faq/ubuntu-enable-setup-automatic-unattended-security-updates/>

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

    systemctl list-units --type service

## Sysctl Tweaks

You can change the setting, see examples: cheatsheets/sysctl-example.md

Edit `/etc/sysctl.conf` and run following command to load changes to sysctl.

    sysctl -p

## Add file system full cronjob

You can make a crontab, when the file system is >80% full we'd like to receive a mail.

    0 9 * * * if [ "`df -l |grep '[8|9][0-9]\%'`" ]; then `df -h|/usr/bin/mail -s 'File system > 80\% full' root` ; fi

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
