# Only outging mailserver

Below the mailserver configuration on:
- Ubuntu-server 24.04 LTS
- Postfix version 3.8.6

## Postfix
If already installed, choose Internet site.

    dpkg-reconfigure postfix

If not installed [Postfix](http://www.postfix.org), choose Internet site.

    apt install postfix

* My [/etc/postfix/main.cf](./main-outgoing.cf) file.
* My [/etc/postfix/master.cf](./master-outgoing.cf) file.
* My [/etc/postfix/bounce.cf](./bounce.cf) file.
* My [/etc/postfix/transport](./transport) file and postmap this file to db.


## TLS certificate

Read more on installing certificates with `acme.sh` on nginx/README.md.

    mkdir -p /etc/letsencrypt/live/server05.igroupware.org

    acme.sh --install-cert -d server05.igroupware.org \
      --fullchain-file /etc/letsencrypt/live/server05.igroupware.org/fullchain.pem \
      --key-file /etc/letsencrypt/live/server05.igroupware.org/privkey.pem \
      --cert-file /etc/letsencrypt/live/server05.igroupware.org/cert.pem

## Sender Policy Framework (SPF)

### SPF records

Create a [SPF](http://www.openspf.org/) record for each domain who we are sending mail, some examples:

    @         TXT           "v=spf1 ip4:91.99.94.83 ip4:159.65.199.31 ip4:146.185.159.154 -all"
Or

    @         TXT           "v=spf1 include:spf.igroupware.org -all"

### DomainKey Identification Mail (DKIM)

    apt install opendkim opendkim-tools

Edit `/etc/opendkim.conf` and change/add to:

````
Socket           local:/var/spool/postfix/opendkim/opendkim.sock

KeyTable         file:/etc/dkimkeys/key.table
SigningTable     file:/etc/dkimkeys/signing.table
InternalHosts    file:/etc/dkimkeys/trusted.hosts
````

Open `/etc/default/opendkim` and change RUNDIR (postfix runs chroot):

    RUNDIR=/var/spool/postfix/opendkim
    SOCKET=local:$RUNDIR/opendkim.sock
    USER=opendkim
    GROUP=postfix
    PIDFILE=$RUNDIR/$NAME.pid
    EXTRAAFTER=

Create rundir in chroot

    mkdir -p /var/spool/postfix/opendkim
    chown -R opendkim:postfix /var/spool/postfix/opendkim

Open `/etc/systemd/system/multi-user.target.wants/opendkim.service` and add next lines to **[service]**

    User=opendkim
    Group=postfix

Your changes won't be applied it you just reload your systemd-configuration files by:

    bash /lib/opendkim/opendkim.service.generate
    systemctl daemon-reload

### Key generation for each domain and setup with DNS.

**Or copy keys from other mailserver if already configured in DNS**

    mkdir /etc/postfix/dkimkeys

    opendkim-genkey -D /etc/dkimkeys/igroupware.org -b 2048 -d igroupware.org -s default
    opendkim-genkey -D /etc/dkimkeys/inzetrooster.nl -b 2048 -d inzetrooster.nl -s default
    opendkim-genkey -D /etc/dkimkeys/filmer.nl -b 2048 -d filmer.nl -s default
    ...

KeyTable `/etc/dkimkeys/key.table`

    default._domainkey.filmer.net filmer.net:default:/etc/dkimkeys/keys/filmer.net/default.private
    default._domainkey.filmer.nl filmer.nl:default:/etc/dkimkeys/keys/filmer.nl/default.private
    ...

SigningTable `/etc/dkimkeys/signing.table`

    filmer.net default._domainkey.filmer.net
    filmer.nl  default._domainkey.filmer.nl
    ...

InternalHosts `/etc/dkimkeys/trusted.hosts`

    127.0.0.1
    ::1
    localhost
    # Server02
    159.223.11.178
    # Server03
    91.99.94.83
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

Set permissions

    chown -R  opendkim:opendkim /etc/dkimkeys/

You may need to add user "postfix" to group "opendkim".

    adduser postfix opendkim

    Create a DNS record for each domain from: `/etc/dkimkeys/keys/filmer.nl/default.txt`.

Or check/test you DKIM on several sites, for example: [dkimcore.org](http://dkimcore.org/tools/keycheck.html)

    default._domainkey      IN      TXT     "v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxYE/Zu4JbLDqC+AzSjoGNGQthLfsewdLPWE9Sf7WiaG9HYtanKclEpbgeJWeDT55jrEnJpSZZdIXPZFOTuSJCNZaZ/Na4iwBRffZFTlA2AGP7wQnZCvhOsCqWCYryLHMFW5/B68WsgR/x5Omzd54TZRJONckIgCD0AbeejX38aMvk3OCP6yA77iWczvjvvmtHBZ4LtC4gHghLoLJllcnm7Bzj/6CzYaFQFMU1McRh1vASR/tj+0S71QG5fwUcVoA20yhIF1UVseZXjrIjGeoeuyBlYjbOPg8eVRTDWFb3rxkacPjXeQepzm+Sc8PI/6llPuNlgiDHU8HYu2nm13IhwIDAQAB"

Test dkim key:

    systemctl restart postfix opendkim
    opendkim-testkey -d filmer.nl -s default -vvv

Debug check persmissions on socket.

    srwxrwx--- 1 opendkim postfix /var/spool/postfix/opendkim/opendkim.sock=

### iptables

````
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

# ip home odido
-A INPUT -s 62.166.142.79 -i eth0 -p tcp -m tcp --dport 587 -j ACCEPT

# server03.igroupware.org
-A INPUT -s 91.99.94.83 -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT

# server02.igroupware.org
-A INPUT -s 159.223.11.178 -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT

# server05.igroupware.org
-A INPUT -s 146.185.159.154 -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT

# server07.igroupware.org
-A INPUT -s 159.69.245.21 -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT

# server08.igroupware.org
-A INPUT -s 159.65.199.31 -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT

# Drop smtp for the rest
-A INPUT -i eth0 -p tcp -m tcp --dport 25 -j DROP

COMMIT
````

### DMARC

Greate a [dmarc](https://dmarc.org/) record for each domain for who we are sending mail.

    _dmarc    TXT   "v=DMARC1; p=quarantine; rua=mailto:postmaster@domain.com;"

* [Control you DMARC process with dmarcian](https://dmarcian.com/)

### DNS Whitelist

Add your ip to [DNSWL.org](http://www.dnswl.org) which provides a Whitelist of known legitimate
email servers to reduce the chances of false positives while spam filtering.

### Logrotate

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

### crontab

Install perl DBI for `bounces-inzetrooster.pl` script (see cheatsheet perl for more info).

````
53 1 * * * "/root/.acme.sh/acme.sh --cron --home /root/.acme.sh" > /dev/null
58 23 * * * /usr/local/sbin/bounces-inzetrooster.pl
59 23 * * * /usr/local/sbin/mail-report.sh | /usr/bin/mail -s "Mail report server05" postmaster@inzetrooster.nl
````

### Checking

    postfix check for open relay

List non default configuration

    postconf -n

Example postfix and opendkim services

    journalctl --follow --unit postfix.service --unit opendkim.service

Check if all services are running:

    ss --tcp --listening --processes --numeric --ipv4
    ss -tlpn4

### Mail-tester

DKIM, SPF and more checker <https://www.mail-tester.com/>
