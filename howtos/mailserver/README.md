The are many howto's for postfix and dovecot mailserver. This howto describe Postfix, Dovecot, ClamAV (antivirus), Spamassasin (antispam), Sender Policy Framwork (SPF), Domain Key Identified Mail (DKIM) and DNS white- blocklisting. It works with SASL and plain text files '''not''' with a mysql database and/or [Postfix Admin](http://postfixadmin.sourceforge.net) for credential storage.

We use the port submission (587) instead of port smtp (25) to **send** mail. Because many ISP's block port 25. This way you can use the smtp server anywhere on this planet with a internet connection.  You also can use a secure connection (TLS or SSL) to fetch your mail via ''imap''. [There is a dutch article howto use this mailserver for clients](/#/post/547c605c98787f50d5aef16b).

Below the mailserver configuration on:
- Ubuntu-server 16.04 LTS
- Postfix version 3.1.0
- Dovecot version 2.2.22

## Postfix 
Install [Postfix](http://www.postfix.org)

    apt-get install postfix 

Check my config files:
* My [main.cf](./main.cf) file.
* My [master.cf](./master.cf) file.

## Create virtual domain/user files 

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

## Create a virtual Mailbox owner 

In our setup all virtual mailboxes are owned by a fixed uid and gid 5000. 

    sudo groupadd -g 5000 vmail
    sudo useradd -m -u 5000 -g 5000 -s /bin/false vmail


## Dovecot 
Install [Dovecot](http://www.dovecot.org)

    apt-get install dovecot-imapd
 
    touch /var/log/dovecot.log
    touch /var/log/dovecot-info.log 
    chown vmail:vmail /var/log/dovecot.log
    chown vmail:vmail /var/log/dovecot-info.log 

Create password file `/etc/dovecot/passwd`. If you want to store [passwords encrypted](http://wiki.dovecot.org/AuthDatabase/PasswdFile)

    # This is a un-encrypted example file
    test:{PLAIN}pass::::
    bill:{PLAIN}secret::::
    timo@example.com:{PLAIN}hello123::::
    dave@example.com:{PLAIN}world234::::
    joe@elsewhere.org:{PLAIN}whee::::
    jane@elsewhere.org:{PLAIN}mypass::::

My [dovecot.conf](./dovecot.conf) (single config) file.

## Spamassassin 
Install [Spamassassin](http://packages.ubuntu.com/trusty/spamass-milter)

    apt-get install spamass-milter

Edit /etc/default/spamass-milter:

    OPTIONS="-u spamass-milter -i 127.0.0.1 -m -r 15 -x"

Restart milter:

    service spamass-milter restart

Add a dedicated user for SpamAssassin daemon:

    adduser --shell /bin/false --home /var/lib/spamassassin --disabled-password --disabled-login --gecos "" spamd

Edit /etc/default/spamassassin:

    OPTIONS="--create-prefs --max-children 5 --helper-home-dir -u spamd -g spamd"
    CRON=1

Run `systemctl enable spamassassin.service` to auto start spamassassin.

Update Spamassassin

    sa-update
    service spamassassin restart

### Testing the spam filter

On a other computer/server: download a text file with the GTUBE signature line and use it as the body of a test email:

    wget -O /tmp/gtube.txt https://spamassassin.apache.org/gtube/gtube.txt
    swaks --from some_existing@email.address --to=someone@example.com --server=your.domain --body=/tmp/gtube.txt

The email should be blocked.

## Clamav 
Postfix now supports Sendmail 8 Milter protocol.

    apt-get install clamav-milter

We need to tell it to let postfix have write access to it's socket. 
Edit `/etc/default/clamav-milter` and uncomment the last line:

    SOCKET_RWGROUP=postfix

Create a [/etc/clamav/clamav-milter.conf](./clamav-milter.conf) file or run:

    dpkg-reconfigure clamav-milter 

Run `freshclam` (make a cron for it, see below)

    freshclam
    service clamav-daemon start
    postconf -e 'smtpd_milters = unix:/clamav/clamav-milter.ctl' # Already in postfix.main.cf file.

## Sender Policy Framework (SPF) 

### DNS/SPF

We want to enabled [SPF](http://www.openspf.org/), so we create a TXT DNS record with the mailservers ipnrs. Examples:

    @         TXT           "v=spf1 ip4:82.201.119.0/24 -all"
    @         TXT           "v=spf1 mx mx:filmer.nl ~all"
    @         TXT           "v=spf1 mx ptr ip4:95.85.60.187 ip6:fe80::601:18ff:fe1b:8e01/64 mx:mail.filmer.nl ~all"

[Wizard for SPF](http://www.microsoft.com/mscorp/safety/content/technologies/senderid/wizard/)

### Postfix/SPF

    sudo apt-get install postfix-policyd-spf-python

Change the line in `/etc/postfix-policyd-spf-python/policyd-spf.conf` to:

    PermError_reject = true

[integrate Sender Policy Framework (SPF) checking with Postfix](https://help.ubuntu.com/community/Postfix/SPF)

## DomainKey Identification Mail (DKIM) 
We also want to use [DKIM](http://www.dkim.org/), so we need to install dkim-filter and create keys.

    sudo apt-get install opendkim opendkim-tools

Opendkim configuration [/etc/opendkim.conf](./mailserver/opendkim.conf) file.

Open `/etc/default/opendkim` and add the next line:

    SOCKET="inet:8891@localhost" # Ubuntu default - listen on loopback on port 8891

* Notice/bug: SOCKET must be the only line, even with comments '#'!

Key generation for dkim-milter and its setup with DNS.

    opendkim-genkey -D /etc/postfix/dkim/ -d filmer.net -s mail

Create a DNS record. Copy `/etc/postfix/dkim/mail.txt`.

Open Postfix main.cf file '/etc/postfix/main.cf' and append the next:

    # DKIM
    milter_default_action = accept
    milter_protocol = 2
    smtpd_milters = inet:localhost:8891
    non_smtpd_milters = inet:localhost:8891

Test dkim key:

    postfix reload
    opendkim-testkey -d filmer.net -s mail -vvv

Or check/test you DKIM on several sites, for example: [dkimcore.org](http://dkimcore.org/tools/keycheck.html)

## RBL countrys

All you need to do to query the DNS zone of countries.nerd.dk is to prepend the IANA country letters to the name and put it in your DNSBL servers you query (xx.countries.nerd.dk). 

    reject_rbl_client kr.countries.nerd.dk,
    reject_rbl_client kp.rcountries.nerd.dk,
    reject_rbl_client cn.rcountries.nerd.dk,
    reject_rbl_client ru.rcountries.nerd.dk,
    .....

* [Toplevel domains](https://en.wikipedia.org/wiki/List_of_Internet_top-level_domains#Country_code_top-level_domains)
* [IPdeny country block downloads](http://www.ipdeny.com/ipblocks/)
* [IP lookup](https://www.ip2location.com/demo)

## DNS Whitelist

[DNSWL.org](http://www.dnswl.org) provides a Whitelist of known legitimate email servers to reduce the chances of false positives while spam filtering. We have the entry ''postscreen_dnsbl_= siteslist.dnswl.org*-5'' [main.cf](/pub/scripts/mailserver/main.cf) to do the job.

## DNS Blocklist
If you want to check if a ipnr is listed use reverse order of subnet io. 139.162.157.247:

    dig 247.157.162.139.b.barracudacentral.org -t txt

Feedback must be something like:

    "Client host blocked using Barracuda Reputation, see http://www.barracudanetworks.com/reputation/?r=1&ip=139.162.157.247"

## Autoreply and Spambox 
Install [Sieve plugin](http://wiki2.dovecot.org/Pigeonhole/Sieve)

    apt-get install dovecot-managesieved dovecot-sieve

With the installed Sieve plugin for autoreply (vacation) message and we want to move ''Spam'' to the spambox.
We have configured ''/etc/dovecot/dovecot.conf'' to use managesieve (see [dovecot.conf](/pub/scripts/mailserver/dovecot.cf)).

Create a `/home/vmail/<domain>/<mailbox>/.dovecot.sieve` file

Example [.dovecot.sieve](./dovecot.sieve) file.

Create a default Sieve file for all users

    /etc/dovecot/default.sieve

## Certificates 
### Postfix

    smtpd_tls_cert_file=/etc/ssl/certificate.crt
    smtpd_tls_key_file=/etc/ssl/private/certificate.key
    smtpd_tls_CAfile=/etc/ssl/cabundle.crt


### Dovecot
Create chained certificate.

    cat /etc/ssl/certificate.crt /etc/ssl/cabundle.crt > /etc/ssl/certificate-chain.crt

Edit `/etc/dovecot/dovecot.conf`
    
    ssl_cert = </etc/ssl/certificate-chain.crt
    ssl_key = </etc/ssl/private/certificate.key

Testing

    openssl s_client -connect mail.filmer.net:imaps


    {Secure Email test](https://www.checktls.com/)

## Configure Bind as Caching or Forwarding DNS server

    sudo apt-get install bind9 bind9utils bind9-doc

Set `/etc/bind/named.conf.options` file:

    acl goodclients {
        95.85.60.187;
        localhost;
        localnets;
    };
    options {
        directory "/var/cache/bind";
        recursion yes;
        allow-query { goodclients; };
        forwarders {
            8.8.8.8;
            8.8.4.4;
        };
        forward only;
        dnssec-enable yes;
        dnssec-validation yes;
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
    };

service bind9 restart

<https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-caching-or-forwarding-dns-server-on-ubuntu-16-04>

## Crontab

We want to refresh ClamAV database, set the correct time on a daily basis and refresh dnswl on a monthly basis.

    0 1 * * * /usr/bin/freshclam --quiet
    0 6 * * * /usr/sbin/ntpdate -s nl.pool.ntp.org
    0 5 * * * /usr/bin/find /home/vmail/ -type f -ctime +30 | grep '/Maildir/.Spam/new' | xargs rm

## If the timezone 'UTC'

    set TimeZone=Centraal Europe Time
    export TZ=CET

## Maintainance en tips 
Check if these services are running: `netstat -lnptu`

    Active Internet connections (only servers)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      1613/sshd·······
    tcp        0      0 0.0.0.0:25              0.0.0.0:*               LISTEN      2110/master·····
    tcp        0      0 127.0.0.1:8891          0.0.0.0:*               LISTEN      1680/opendkim···
    tcp        0      0 0.0.0.0:993             0.0.0.0:*               LISTEN      1636/dovecot····
    tcp        0      0 0.0.0.0:995             0.0.0.0:*               LISTEN      1636/dovecot····
    tcp        0      0 95.85.60.187:3306       0.0.0.0:*               LISTEN      1843/mysqld·····
    tcp        0      0 0.0.0.0:587             0.0.0.0:*               LISTEN      2110/master·····
    tcp        0      0 0.0.0.0:110             0.0.0.0:*               LISTEN      1636/dovecot····
    tcp        0      0 127.0.0.1:783           0.0.0.0:*               LISTEN      7608/spamassassin.p
    tcp        0      0 0.0.0.0:143             0.0.0.0:*               LISTEN      1636/dovecot····
    tcp6       0      0 :::25                   :::*                    LISTEN      2110/master·····
    tcp6       0      0 :::993                  :::*                    LISTEN      1636/dovecot····
    tcp6       0      0 :::995                  :::*                    LISTEN      1636/dovecot····
    tcp6       0      0 :::587                  :::*                    LISTEN      2110/master·····
    tcp6       0      0 :::110                  :::*                    LISTEN      1636/dovecot····
    tcp6       0      0 ::1:783                 :::*                    LISTEN      7608/spamassassin.p
    tcp6       0      0 :::143                  :::*                    LISTEN      1636/dovecot·

