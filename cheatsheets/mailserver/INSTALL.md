# Postfix incomming mailserver

This file is focused on incomming mail. We use Postfix, Dovecot, ClamAV (antivirus), Spamassasin (antispam),
Sender Policy Framwork (SPF), Domain Key Identified Mail (DKIM) and DNS white- blocklisting.

Below the mailserver configuration on:
- Ubuntu-server 24.04 LTS
- Postfix version 3.8.6
- Dovecot version 2.4.0.2

## Dovecot

Install [Dovecot](https://repo.dovecot.org/) with version 2.4

    curl https://repo.dovecot.org/DOVECOT-REPO-GPG-2.4 | gpg --dearmor > /usr/share/keyrings/dovecot.gpg

Create `/etc/apt/sources.list.d/dovecot.list` and add:

    deb [signed-by=/usr/share/keyrings/dovecot.gpg] https://repo.dovecot.org/ce-2.4-latest/ubuntu/noble noble main

Install dovecot

    apt install dovecot-imapd dovecot-lmtpd

### Create a virtual Mailbox owner

In our setup all virtual mailboxes are owned by a fixed uid and gid 5000.

    sudo groupadd -g 5000 vmail
    sudo useradd -m -u 5000 -g 5000 -s /bin/false vmail
    touch /var/log/dovecot.log
    touch /var/log/dovecot-info.log
    touch /etc/dovecot/passwd
    mkdir /var/vmail/
    chown vmail:vmail /var/log/dovecot.log
    chown vmail:vmail /var/log/dovecot-info.log
    chown vmail:vmail /etc/dovecot/passwd
    chown vmail:vmail /var/vmail

Change password file `/etc/dovecot/passwd` to your needs.
 If you want to store [passwords encrypted](https://doc.dovecot.org/configuration_manual/authentication/passwd_file/)

    # This is a un-encrypted example file
    test:{PLAIN}pass::::
    bill:{PLAIN}secret::::
    timo@example.com:{PLAIN}hello123::::
    dave@example.com:{PLAIN}world234::::
    joe@elsewhere.org:{PLAIN}whee::::
    jane@elsewhere.org:{PLAIN}mypass::::


My [/etc/dovecot/dovecot.conf](./dovecot.conf) (single config) file.

### Certs

Check if mail clients can get the cerfificates

    openssl s_client -connect mail.igroupware.org:993 -showcerts
    openssl s_client -connect mail.filmer.nl:587 -showcerts

## Postfix
* First configurations are in [INSTAll-outgoing.md](./INSTALL-outgoing.md) file.

Check my config files for incomming and outgoing:

* My [/etc/postfix/main.cf](./main.cf) file.
* My [/etc/postfix/master.cf](./master.cf) file.

### Create virtual domain/user files

File: /etc/postfix/vdomains

    example.org -

File: /etc/postfix/vmailboxes

    andries@example.org -

File: /etc/postfix/valiases

    @example.org andries@example.org
    @example.com andries@example.org

Hash these file after every change

    postmap /etc/postfix/vdomains
    postmap /etc/postfix/vmailboxes
    postmap /etc/postfix/valiases

### Client & Sender checks

Create [/etc/postfix/client_checks](./client_checks) and [/etc/postfix/sender_checks](./sender_checks)

    postmap /etc/postfix/client_checks
    postmap /etc/postfix/sender_checks

### Postfix/SPF

    sudo apt install postfix-policyd-spf-python

Change the line in `/etc/postfix-policyd-spf-python/policyd-spf.conf` to:

    PermError_reject = true

Add these lines to `/etc/postfix/master.conf`

````
policy-spf  unix  -       n       n       -       -       spawn
     user=nobody argv=/usr/bin/policyd-spf
````

## Greylisting

    apt install postgrey

Enable this service in `/etc/postfix/main.cf`

    smtpd_recipient_restrictions = permit_mynetworks,
                                   permit_sasl_authenticated,
                                   reject_unauth_destination,
                                   check_policy_service inet:127.0.0.1:10023
                                   ....

Change delay to one minuut instead of 5 minutes in `/etc/default/postgrey`. Use TCP or file socket

    POSTGREY_OPTS="--unix=/var/spool/postfix/private/postgrey --delay=60"
    #POSTGREY_OPTS="--inet=127.0.0.1:10023 --delay=60"


## iptables
Change iptables so it accepts incomming mail, imap and submission

`/etc/iptables/rules.v4`
````
-A INPUT -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT
-A INPUT -i eth0 -p tcp -m tcp --dport 143 -j ACCEPT
-A INPUT -i eth0 -p tcp -m tcp --dport 587 -j ACCEPT
````

`/etc/iptables/rules.v6`
````
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A FORWARD -o eth0 -j REJECT --reject-with icmp6-port-unreachable
COMMIT
````

    iptables-restore < /etc/iptables/rules.v4
    ip6tables-restore < /etc/iptables/rules.v6

## unbound caching nameserver DNS

For blocklist resolving ipnrs we need a local caching dns server.

    apt install unbound

Edit `/etc/unbound/unbound.conf`, see [example file](./unbound.conf)

Edit `/etc/systemd/resolved.conf` and add/change:

    [Resolve]
    DNS=127.0.0.1
    # Allowed dns for blocklists
    # Quad9: 9.9.9.9 149.112.112.112
    # Opendns 208.67.222.222
    #FallbackDNS=9.9.9.9 149.112.112.112 208.67.222.222
    FallbackDNS=
    DNSStubListener=no

Remove current `resolv.conf` file.

     /etc/resolv.conf -> ../run/systemd/resolve/stub-resolv.conf

Create a new `/etc/resolv.conf` file.

    echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf

Testing

    dig @127.0.0.1 somedomainname.comm
    systemctl restart systemd-resolved
    resolvectl status

You should see: `DNS Server: 127.0.0.1`

## Sieve

    apt install dovecot-sieve dovecot-managesieved

Let sieve scripts do there work. Edit `/etc/systemd/system/multi-user.target.wants/dovecot.service` and add:

    ReadWritePaths=/etc/dovecot/sieve/

Reload the units with:

    systemctl daemon-reload
    systemctl restart dovecot

## Spamassassin

    apt install spamass-milter

Create a crontab for example

    20 4 10 * * /usr/bin/sa-update

Append this line in `/etc/postfix/main.conf` to smtpd_milters (comma separated)

    smtpd_milters = unix:/spamass/spamass.sock

Edit `/etc/default/spamd`

    OPTIONS="--create-prefs --max-children 5 --helper-home-dir --nouser-config -u spamass-milter -g spamass-milter"

Disable rbl checking in `/etc/spamassassin/local.cf`

    skip_rbl_checks 1

### Testing the spam filter

On a other computer/server: download a text file with the GTUBE signature line and use it as the body of a test email:

    wget -O /tmp/gtube.txt https://spamassassin.apache.org/gtube/gtube.txt

From a other server

    swaks --from some_existing@email.address --to=someone@example.com --server=your.domain --body=</tmp/gtube.txt

The email should be blocked.

## Clamav

Postfix now supports Sendmail 8 Milter protocol.

    apt install clamav-milter
    mkdir /var/spool/postfix/clamav
    chown clamav:postfix /var/spool/postfix/clamav

Edit `/usr/lib/systemd/system/clamav-daemon.socket`

    ListenStream=/var/spool/postfix/clamav/clamd.ctl

Run daemon-reload

    systemctl daemon-reload

Edit `/etc/clamav/clamav-milter.conf`

    MilterSocket /var/spool/postfix/clamav/clamav-milter.ctl
    ClamdSocket unix:/var/spool/postfix/clamav/clamd.ctl

Edit `/etc/clamav/clamd.conf`

    LocalSocket /var/spool/postfix/clamav/clamd.ctl

Append this line in `/etc/postfix/main.conf` to smtpd_milters (comma separated)

    smtpd_milters = unix:/clamav/clamav-milter.ctl

Check if the services are running

    systemctl status clamav-*

We want to refresh ClamAV database on a daly basis, for example.

Edit `/usr/lib/systemd/system/clamav-freshclam.service` and add:

    User=clamav

Do we need a crontab if freshclam is running as a service?

    25 5 * * * /usr/bin/freshclam --quiet

## fail2ban

Edit `/etc/fail2ban/jail.local` and add:

````
[DEFAULT]
#          localhost   home-ip        server01        server02       server04        server05        server08
ignoreip = 127.0.0.1/8 87.209.180.24  178.128.254.144 159.223.11.178 146.190.236.166 146.185.159.154 159.65.199.31

banaction = iptables

[postfix-flood-attack]
enabled  = true
filter   = postfix-flood-attack
journalmatch = _SYSTEMD_UNIT=postfix.service
backend = auto
action   = iptables-multiport[name=postfix, port="http,https,smtp,submission,imap,imaps,sieve", protocol=tcp]
logpath  = /var/log/mail.log
maxretry = 3
bantime  = 1h

[postfix]
enabled = true
filter = postfix[mode=aggressive]
logpath = /var/log/mail.log
maxretry = 3
bantime = 1h

[dovecot]
enabled = true
port = imap,imaps
filter = dovecot
logpath = /var/log/dovecot.log
maxretry  = 3
````

Create a defination `/etc/fail2ban/filter.d/postfix-flood-attack.conf`

````
[Definition]
failregex = lost connection after AUTH from (.*)\[<HOST>\]
ignoreregex =
````

