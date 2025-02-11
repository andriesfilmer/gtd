# Only outging mailserver

Below the mailserver configuration on:
- Ubuntu-server 24.04 LTS
- Postfix version 3.8.6

## Postfix
If already installed, choose Internet site.

    dpkg-reconfigure postfix

If not installed [Postfix](http://www.postfix.org), choose Internet site.

    apt install postfix

Edit `/etc/postfix/main.cf` and change/add.


````
smtpd_banner = $myhostname ESMTP $mail_name (ShiftPlanner)
biff = no
append_dot_mydomain = no
readme_directory = no
compatibility_level = 3.6

# TLS parameters
smtp_use_tls = yes
smtp_tls_CApath=/etc/ssl/certs
smtp_tls_security_level=may
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

smtpd_use_tls = yes
smtpd_tls_CAfile = /etc/letsencrypt/live/server05.igroupware.org/fullchain.pem
smtpd_tls_key_file = /etc/letsencrypt/live/server05.igroupware.org/privkey.pem
smtpd_tls_cert_file = /etc/letsencrypt/live/server05.igroupware.org/cert.pem

smtpd_tls_received_header = yes
smtpd_tls_mandatory_protocols = TLSv1.2, TLSv1.3
smtpd_tls_mandatory_ciphers = medium
smtpd_tls_auth_only = yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtpd_tls_security_level=may

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = server05.igroupware.org
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
myorigin = /etc/mailname
mydestination = $myhostname, server05.igroupware.org, localhost.igroupware.org, , localhost
relayhost =

# Trusted network
# server01.filmer.nl 178.128.254.144
# server02.igroupware.org 159.223.11.178
# server03.filmer.net: 95.85.60.187
# server04.igroupware.org 146.190.236.166
# server05.igroupware.org 146.185.159.154
# server07.igroupware.org 159.69.245.21
# Home ip: 87.209.180.24
mynetworks = 127.0.0.0/8, 178.128.254.144, 159.223.11.178, 95.85.60.187, 146.190.236.166, 146.185.159.154, 159.69.245.21, 87.209.180.24

# 20MB
message_size_limit = 20480000
# Unsuccessful delivery attempt
maximal_queue_lifetime = 2d
# MAILERD-DAEMON
bounce_queue_lifetime = 1d
bounce_template_file = /etc/postfix/bounce.cf

# DKIM
milter_default_action = accept
milter_protocol = 6
non_smtpd_milters = unix:/run/opendkim/opendkim.sock
smtpd_milters = unix:/run/opendkim/opendkim.sock

# Limit outgoing mail throttling
smtp_destination_concurrency_limit = 2
smtp_destination_rate_delay = 6s
smtp_extra_recipient_limit = 10

# Limit by domain
#----------------
transport_maps = hash:/etc/postfix/transport
#
# Polite policy
polite_destination_concurrency_limit = 3
polite_destination_rate_delay = 10s
polite_destination_recipient_limit = 5

# Turtle policy
turtle_destination_concurrency_limit = 2
turtle_destination_rate_delay = 30s
turtle_destination_recipient_limit = 2
````

Edit `/etc/postfix/master.cf`

Uncomment submission port 387 for testing local, because port 25 is not available from home ip.

    submission inet n       -       y       -       -       smtpd

Limit outgoing mail throttling

    polite    unix  -       -       n       -       -       smtp
    turtle    unix  -       -       n       -       -       smtp

Create a transport file `/etc/postfix/transport`

````
# Polite
hotmail.com polite:
outlook.com polite:
gmail.com polite:

# Turtle
icloud.com turtle:
me.com turtle:
ziggo.nl turtle:
casema.nl turtle:
quicknet.nl turtle:

# Other examples
#postmaster@filmer.nl smtp:[server08.igroupware.org]
#
# Typo's
#mellolizwaan@outlouk.com        error:5.1.2 Bad destination system address
````

    postmap /etc/postfix/transport

## TLS certificate

Read more on installing `acme.sh` on nginx/README.md.

    mkdir -p /etc/letsencrypt/live/server05.igroupware.org

    acme.sh --install-cert -d server05.igroupware.org \
      --fullchain-file /etc/letsencrypt/live/server05.igroupware.org/fullchain.pem \
      --key-file /etc/letsencrypt/live/server05.igroupware.org/privkey.pem \
      --cert-file /etc/letsencrypt/live/server05.igroupware.org/cert.pem

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

    opendkim-genkey -D /etc/postfix/dkim/keys/filmer.net -b 2048 -d filmer.net -s default
    opendkim-genkey -D /etc/postfix/dkim/keys/filmer.nl -b 2048 -d filmer.nl -s default
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
    # Server02
    159.223.11.178
    # Server03
    95.85.60.187
    # Server04
    146.190.236.166
    # Server05
    146.185.159.154
    # Server07
    159.69.245.21
    # Ip home
    87.209.180.24
    *.igroupware.org
    *.inzetrooster.nl
    *.filmer.nl

Opendkim needs permissions but postfix complains about **warning: group or other writable:**?!

    chown -R  opendkim:postfix /etc/postfix/dkim

Create a DNS record for each domain from: `/etc/opendkim/keys/filmer.nl/default.txt`.

Or check/test you DKIM on several sites, for example: [dkimcore.org](http://dkimcore.org/tools/keycheck.html)

    default._domainkey      IN      TXT     "v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxYE/Zu4JbLDqC+AzSjoGNGQthLfsewdLPWE9Sf7WiaG9HYtanKclEpbgeJWeDT55jrEnJpSZZdIXPZFOTuSJCNZaZ/Na4iwBRffZFTlA2AGP7wQnZCvhOsCqWCYryLHMFW5/B68WsgR/x5Omzd54TZRJONckIgCD0AbeejX38aMvk3OCP6yA77iWczvjvvmtHBZ4LtC4gHghLoLJllcnm7Bzj/6CzYaFQFMU1McRh1vASR/tj+0S71QG5fwUcVoA20yhIF1UVseZXjrIjGeoeuyBlYjbOPg8eVRTDWFb3rxkacPjXeQepzm+Sc8PI/6llPuNlgiDHU8HYu2nm13IhwIDAQAB"

Test dkim key:

    postfix reload
    opendkim-testkey -d filmer.nl -s default -vvv

Debug check persmissions on socket.

    srwxrwx--- 1 opendkim postfix /var/spool/postfix/run/opendkim/opendkim.sock=

## iptables

````
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -s 95.85.60.187/32 -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT
-A INPUT -s 159.223.11.178 -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT
-A INPUT -s 198.199.127.67/32 -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT
-A INPUT -s 159.69.245.21/32 -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT
-A INPUT -s 87.209.180.24 -i eth0 -p tcp -m tcp --dport 587 -j ACCEPT
-A INPUT -i eth0 -p tcp -m tcp --dport 587 -j DROP
-A INPUT -i eth0 -p tcp -m tcp --dport 25 -j DROP
COMMIT
````

## DMARC

Greate a [dmarc](https://dmarc.org/) record for each domain for who we are sending mail.

    _dmarc    TXT   "v=DMARC1; p=quarantine; rua=mailto:postmaster@domain.com;"

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

## crontab

    apt install mailutils

````
53 1 * * * "/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" > /dev/null
58 23 * * * /usr/local/sbin/bounces-inzetrooster.pl
59 23 * * * /usr/bin/cat /var/log/mail.log | grep -o -P 'from=<(.+?)>' | sort | uniq -c | sort -nr | head -n20 | /usr/bin/mail -s "Mail server08 top 20" postmaster@domain.com
````

## Checking

    postfix check for open relay

Example postfix and opendkim services

    journalctl --follow --unit postfix.service --unit opendkim.service

Check if all services are running:

    ss --tcp --listening --processes --numeric --ipv4
    ss -tlpn4


### Mail-tester

DKIM, SPF and more checker <https://www.mail-tester.com/>
