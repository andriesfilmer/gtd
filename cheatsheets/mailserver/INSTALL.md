# Postfix incomming mailserver

This file is focused on incomming mail. We use Postfix, Dovecot, ClamAV (antivirus), Spamassasin (antispam),
Sender Policy Framwork (SPF), Domain Key Identified Mail (DKIM) and DNS white- blocklisting.
It works with SASL and plain text files '''not''' with a mysql database and/or [Postfix Admin](http://postfixadmin.sourceforge.net) for credential storage.

We use the port submission (587) instead of port smtp (25) to **send** mail.

Below the mailserver configuration on:
- Ubuntu-server 24.04 LTS
- Postfix version 3.8.6
- Dovecot version 2.4.0.2

## Dovecot

Install [Dovecot](https://repo.dovecot.org/) with version 2.4

    apt install dovecot-imapd
    apt install dovecot-lmtpd

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

## Postfix
* First configurations are in [INSTAll-outgoing.md](./INSTALL-outgoing.md) file.

Check my config files for incomming and outgoing:

* My [/etc/postfix/main.cf](./main.cf) file.
* My [/etc/postfix/master.cf](./master.cf) file.

Reconfigure postfix?

    dpkg-reconfigure postfix

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

Change delay to one minuut instead of 5 minutes in `/etc/default/postgrey`

    POSTGREY_OPTS="--inet=127.0.0.1:10023 --delay=60"

## iptables
Change iptables so it accepts incomming mail, imap and submission

````
-A INPUT -i eth0 -p tcp -m tcp --dport 25 -j ACCEPT
-A INPUT -i eth0 -p tcp -m tcp --dport 143 -j ACCEPT
-A INPUT -i eth0 -p tcp -m tcp --dport 587 -j ACCEPT
````

## unbound caching nameserver DNS

    apt-get install unbound

Edit `/etc/systemd/resolved.conf` and add/change:

    [Resolve]
    DNS=127.0.0.1
    FallbackDNS=9.9.9.9 149.112.112.112 208.67.222.222
    DNSStubListener=no

Generate new `/etc/resolve.conf` file.

    systemctl restart systemd-resolved
    resolvectl status

You should see: `Current DNS Server: 127.0.0.1`

## Sieve

    apt install dovecot-sieve dovecot-managesieved

## Spamassassin

    apt install spamass-milter

Create a crontab for example

    20 4 10 * * /usr/bin/sa-update

Append this line in `/etc/postfix/main.conf` to smtpd_milters (comma separated)

    smtpd_milters = unix:/spamass/spamass.sock

Edit `/etc/default/spamd`

    #OPTIONS="--create-prefs --max-children 5 --helper-home-dir"
    OPTIONS="--create-prefs --max-children 5 --helper-home-dir -u spamd -g spamd"

### Testing the spam filter

On a other computer/server: download a text file with the GTUBE signature line and use it as the body of a test email:

    wget -O /tmp/gtube.txt https://spamassassin.apache.org/gtube/gtube.txt
    swaks --from some_existing@email.address --to=someone@example.com --server=your.domain --body=/tmp/gtube.txt

The email should be blocked.

[Must read for spamassassin blocklists](https://cwiki.apache.org/confluence/display/spamassassin/DnsBlocklists#dnsbl-block)
if you have errors like `DNSBL blocked you due to too many querie`. Disable these messages in `/etc/spamassassin/local.cf`

    skip_rbl_checks 1

## Clamav

Postfix now supports Sendmail 8 Milter protocol.

    apt install clamav-milter

Edit `/etc/clamav/clamav-milter.conf`

    MilterSocket /var/spool/postfix/run/clamav/clamav-milter.ctl
    ClamdSocket unix:/run/clamav/clamd.ctl
    MilterSocketGroup postfix

Append this line in `/etc/postfix/main.conf` to smtpd_milters (comma separated)

    smtpd_milters = unix:/run/clamav/clamav-milter.ctl
    smtpd_milters = unix:/var/spool/postfix/run/clamav/clamav-milter.ctl

Check if the services are running

    systemctl status clamav*

Testing clamav

    echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > eicar.com
    clamscan eicar.com


## fail2ban

Edit `/etc/fail2ban/jail.local` and add:

    [dovecot]
    enabled = true

