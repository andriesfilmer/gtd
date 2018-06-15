# First configurations for a Ubuntu server

## update

    apt-get update
    apt-get upgrade

## Fail2ban

    apt-get install fail2ban

Open /etc/fail2ban/jail.conf and add your own ip's:

    ignoreip = 127.0.0.1/8 194.242.19.102 95.85.60.187 84.106.235.36

## Iptable rules

After the install off fail2ban save the current [iptables](https://wiki.debian.org/iptables) configuration.

    iptables-save > /etc/iptables.rules

Then add some custom rules before 'COMMIT' in '/etc/iptables.rules'

    # MySql/Mariadb
    -A INPUT -s 37.139.4.122   -i eth0 -p tcp -m tcp --dport 3306 -j ACCEPT
    -A INPUT -s 198.211.123.93 -i eth0 -p tcp -m tcp --dport 3306 -j ACCEPT
    -A INPUT -i eth0 -p tcp -m tcp --dport 3306 -j DROP

Reconfigure de firewall

    iptables-restore < /etc/iptables.rules

Create a file '/etc/network/if-pre-up.d/iptables' to make this permanent after reboot.

    #!/bin/sh
    /sbin/iptables-restore < /etc/iptables.rules

The file needs to be executable so change the permissions:

    chmod +x /etc/network/if-pre-up.d/iptables

## SSH

Disable root logins via ssh. Edit /etc/ssh/sshd_config

    PermitRootLogin no

Only ssh with IPv4

    AddressFamily inet

Restart ssh daemon

    /etc/init.d/ssh restart

### hosts.allow

[Allow ssh from dutch providers](http://nirsoft.net/countryip/nl.html)

These are **my** provider blocks

    # 81.204.0.0/14   KPN
    # 84.104.0.0/14   ZIGGO
    # 217.62.16.0/20  ZIGGO
    # 84.241.192.0/18 T-MOBILE
    #
    # 198.211.123.93  server02
    # 95.85.60.187    server03
    # 37.139.3.138    server04

    sshd: 81.204.0.0/14 84.104.0.0/14 217.62.16.0/20 84.241.192.0/18 198.211.123.93 95.85.60.187 37.139.3.138


### hosts.deny

And disable access from all others in `/etc/hosts.deny`

    sshd: ALL

## .bashrc

Add these lines to /root/.bashrc

    bind '"e[A"':history-search-backward
    bind '"e[B"':history-search-forward

## Timezone

    sudo dpkg-reconfigure tzdata

Crontab

    0 1 * * * /usr/bin/timedatectl

## Automatic Updates

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

    dd if=/dev/zero of=/swapfile bs=1024 count=1024k
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

### Google DNS
- Preferred: 8.8.8.8
- Alternate: 8.8.4.4

### OpenDNS
- Preferred: 208.67.222.222
- Alternate: 208.67.220.220

## Logwatch

    apt-get install logwatch

Add a few options to logwatch.conf (I also like my output formatted in html)

    echo "Range = between -7 days and -1 days" >> /etc/logwatch/conf/logwatch.conf
    echo "Output = html" >> /etc/logwatch/conf/logwatch.conf

By default logwatch installs itself in /etc/cron.daily, you should move it to /etc/cron.weekly

    mv /etc/cron.daily/00logwatch /etc/cron.weekly

Because sshd has `PermitRootLogin No` I ignore root login attempts. It has too many entries :(
Open `/usr/share/logwatch/default.conf/services/sshd.conf` and add:

    *Remove = root

[Digitalocean - Logwatch Log Analyzer and Reporter](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-logwatch-log-analyzer-and-reporter-on-a-vps)

## Add file system full cronjob

If you don't look at or use `logwatch` you can make a crontab, when the file system is >80% full we'd like to receive a mail.

    0 9 * * * if [ "`df -l |grep '[8|9][0-9]%'`" ]; then `df -h|/usr/bin/mail -s 'File system > 80% full' root` ; fi

