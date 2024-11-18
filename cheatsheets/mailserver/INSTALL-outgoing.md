
Below the mailserver configuration on:
- Ubuntu-server 24.04 LTS
- Postfix version 3.8.6

## Postfix
Install [Postfix](http://www.postfix.org) and choose Internet site.

    apt install postfix

Edit `/etc/postfix/main.cf` and change/add.

````
# Trusted network
# server01.filmer.nl 178.128.254.144
# server02.igroupware.org 159.223.11.178
# server03.filmer.net: 95.85.60.187
# server04.igroupware.org 146.190.236.166
# server05.igroupware.org 146.185.159.154
# Home ip: 87.209.180.24
mynetworks = 127.0.0.0/8, 178.128.254.144, 159.223.11.178, 95.85.60.187, 146.190.236.166, 146.185.159.154, 87.209.180.24

# DKIM
milter_default_action = accept
milter_protocol = 6
non_smtpd_milters = unix:/run/opendkim/opendkim.sock
smtpd_milters = unix:/run/opendkim/opendkim.sock
````

Edit `/etc/postfix/master.cf` and uncomment submission port 387.

    submission inet n       -       y       -       -       smtpd

## Sender Policy Framework (SPF)

### SPF records

Create a [SPF](http://www.openspf.org/) record for each domain who we are sending mail, some examples:

    @         TXT           "v=spf1 ip4:95.85.60.187 ip4:159.65.199.31 ip4:146.185.159.154 -all"
Or

    @         TXT           "v=spf1 include:spf.igroupware.org -all"

## DomainKey Identification Mail (DKIM)

    apt install opendkim opendkim-tools

Edit `/etc/opendkim.conf` and change/add to:

````
Socket           local:/var/spool/postfix/run/opendkim/opendkim.sock

KeyTable         file:/etc/postfix/dkim/key.table
SigningTable     file:/etc/postfix/dkim/signing.table
InternalHosts    file:/etc/postfix/dkim/trusted.hosts
````

Open `/etc/default/opendkim` and change RUNDIR (postfix runs chroot):

    RUNDIR=/var/spool/postfix/run/opendkim
    SOCKET=local:$RUNDIR/opendkim.sock
    USER=opendkim
    GROUP=postfix
    PIDFILE=$RUNDIR/$NAME.pid
    EXTRAAFTER=

Create rundir in chroot

    mkdir -p /var/spool/postfix/run/opendkim
    chown -R opendkim:postfix /var/spool/postfix/run

Open `/etc/systemd/system/multi-user.target.wants/opendkim.service` and add next lines to **[service]**

    User=opendkim
    Group=postfix

Your changes won't be applied it you just reload your systemd-configuration files by:

    bash /lib/opendkim/opendkim.service.generate
    systemctl daemon-reload

Key generation for each domain and setup with DNS.

**Or copy keys from other mailserver if already configured in DNS**

    mkdir -p /etc/postfix/dkim/keys

    opendkim-genkey -D /etc/opendkim/keys/filmer.net -b 2048 -d filmer.net -s default
    opendkim-genkey -D /etc/opendkim/keys/filmer.nl -b 2048 -d filmer.nl -s default
    ...

KeyTable `/etc/postfix/dkim/key.table`

    default._domainkey.filmer.net filmer.net:default:/etc/postfix/dkim/keys/filmer.net/default.private
    default._domainkey.filmer.nl filmer.nl:default:/etc/postfix/dkim/keys/filmer.nl/default.private
    ...

SigningTable `/etc/postfix/dkim/signing.table`

    filmer.net default._domainkey.filmer.net
    filmer.nl  default._domainkey.filmer.nl
    ...

InternalHosts `/etc/postfix/dkim/trusted.hosts`

    127.0.0.1
    ::1
    localhost
    # Server03
    95.85.60.187
    # Server04
    146.190.236.166
    # Server05
    146.185.159.154
    # Ip home
    87.209.180.24
    *.igroupware.org
    *.inzetrooster.nl
    *.filmer.nl

Opendkim needs permissions but postfix complains about **warning: group or other writable:**?!

    chown -R  opendkim:postfix /etc/postfix/dkim
    find /etc/postfix/dkim/ -type f -exec chmod 664 {} \;
    find /etc/postfix/dkim/ -type d -exec chmod 775 {} \;

Create a DNS record for each domain from: `/etc/opendkim/keys/filmer.nl/default.txt`.

Or check/test you DKIM on several sites, for example: [dkimcore.org](http://dkimcore.org/tools/keycheck.html)

    default._domainkey      IN      TXT     "v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxYE/Zu4JbLDqC+AzSjoGNGQthLfsewdLPWE9Sf7WiaG9HYtanKclEpbgeJWeDT55jrEnJpSZZdIXPZFOTuSJCNZaZ/Na4iwBRffZFTlA2AGP7wQnZCvhOsCqWCYryLHMFW5/B68WsgR/x5Omzd54TZRJONckIgCD0AbeejX38aMvk3OCP6yA77iWczvjvvmtHBZ4LtC4gHghLoLJllcnm7Bzj/6CzYaFQFMU1McRh1vASR/tj+0S71QG5fwUcVoA20yhIF1UVseZXjrIjGeoeuyBlYjbOPg8eVRTDWFb3rxkacPjXeQepzm+Sc8PI/6llPuNlgiDHU8HYu2nm13IhwIDAQAB"

Test dkim key:

    postfix reload
    opendkim-testkey -d filmer.nl -s default -vvv

Debug check persmissions

    srwxrwx--- 1 opendkim postfix /var/spool/postfix/run/opendkim/opendkim.sock=

## DMARC

Greate a [dmarc](https://dmarc.org/) record for each domain for who we are sending mail.

    _dmarc    TXT   "v=DMARC1; p=quarantine; rua=mailto:postmaster@domain.nl;"

* [Control you DMARC process with dmarcian](https://dmarcian.com/)

## DNS Whitelist

[DNSWL.org](http://www.dnswl.org) provides a Whitelist of known legitimate email servers to reduce the chances of false positives while spam filtering. We have the entry ''postscreen_dnsbl_= siteslist.dnswl.org*-5'' [main.cf](/pub/scripts/mailserver/main.cf) to do the job.

## Logrotate

Create a new configuration file for Postfix logs in the logrotate `/etc/logrotate.d/postfix`

    /var/log/mail.info
    /var/log/mail.warn
    /var/log/mail.err
    /var/log/mail.log
    {
        su root adm
        rotate 20
        daily
        compress
        missingok
        postrotate
                /usr/lib/rsyslog/rsyslog-rotate
        endscript
    }

remove the mail.* config from `/etc/logrotate.d/rsyslog`

Test and execute logrotate on Postfix manually:

    logrotate -f /etc/logrotate.d/postfix
    logrotate -v -d /etc/logrotate.conf   # Turn on debug mode, which means that no changes are made
    logrotate -v -f /etc/logrotate.conf   # Tells logrotate to force the rotation, even if it doesn't think this is necessary

## Checking

    postfix check for open relay

Example postfix and opendkim services

    journalctl --follow --unit postfix.service --unit opendkim.service

Check if all services are running:

    ss --tcp --listening --processes --numeric --ipv4
    ss -tlpn4


### Mail-tester

DKIM, SPF and more checker <https://www.mail-tester.com/>
