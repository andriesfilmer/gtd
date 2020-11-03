## Install

* [My mailserver install](./INSTALL.md)
* [Traditional testing](./debug.md)
* Blacklist check <https://mxtoolbox.com/blacklists.aspx>
* Test the Spammyness of your emails <https://www.mail-tester.com/>

## Swaks - SMTP transaction tester

    sudo apt-get install swaks

Simple test

    swaks --from andries@inzetrooster.nl --to=andries.filmer@gmail.com --server=server03.filmer.net
    swaks -t andries.filmer@gmail.com -f andries@filmer.nl -a -tls -au andries@filmer.nl -ap "mypasswd" -s mail.filmer.nl

## Postfix

    postfix check for open relay

## Dovecot

As a general tip for debug the config if dovecot is not starting

    dovecot -F

## Mail queue

View postfix queue

    mailq
or
    postqueue -p

Retry sending of all messages in queue

    postqueue -f

Read mail from queue

    postcat -vq XXXXXXXXXX

Delete specfic mail

    postsuper -d XXXXXXXXXX

Delete all queued mail

    postsuper -d ALL

Delete only the differed mail queue messages (i.e. only the ones the system intends to retry later)

    postsuper -d ALL deferred

Remove specific emails (i.o. andriesfilmer@hotmail.com)

    mailq | grep -v '^ *(' | awk  'BEGIN { RS = "" } { if ($7 == "andriesfilmer@hotmail.com" && $9 == "") print $1 } ' | tr -d '*!' | postsuper -d -

## Query the logfile

Find hard bounces

    grep " dsn=5." /var/log/mail.log | grep -o -P " to=<(.+?)>" | sort | uniq -c

See how many mails are blocked

cat /var/log/mail.log | grep 'listed by domain' | awk '{print $11}' | sort | uniq -c

Who is polluting the logfile: NOQUEUE: reject: RCPT from unknown

    cat /var/log/mail.log | grep 'NOQUEUE: reject:' | awk '{print $10 " " $17}' | sort | uniq -c

Checking postscreen ranking

    cat /var/log/mail.log | grep 'DNSBL rank'

Checking returning mailservers

    cat /var/log/mail.log | grep 'PASS OLD' | awk '{print $6 " " $7 " " $8}' | sort | uniq -c

Get ipnrs sorted by connection

    cat /var/log/mail.log | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq -c | sort -n

Get list of countries with auth failed

   grep "auth failed" tmp/mail.log | egrep -o "[0-9\.]{7,15}" | awk '{print $NF}' | xargs -n1 geoiplookup | sort | uniq -c | sort -rn | head | tee top-countries-imap-auth-failed.txt

##  SMTP reply codes

See rfc2821 for the basic specification of SMTP; see also rfc1123 for important additional information.
See rfc1893 and rfc2034 for information about enhanced status codes

    Check the RFC index for further mail-related RFCs.
    Reply codes in numerical order Code   Meaning
    200   (nonstandard success response, see rfc876)
    211   System status, or system help reply
    214   Help message
    220   <domain> Service ready
    221   <domain> Service closing transmission channel
    250   Requested mail action okay, completed
    251   User not local; will forward to <forward-path>
    354   Start mail input; end with <CRLF>.<CRLF>
    421   <domain> Service not available, closing transmission channel
    450   Requested mail action not taken: mailbox unavailable
    451   Requested action aborted: local error in processing
    452   Requested action not taken: insufficient system storage
    500   Syntax error, command unrecognised
    501   Syntax error in parameters or arguments
    502   Command not implemented
    503   Bad sequence of commands
    504   Command parameter not implemented
    521   <domain> does not accept mail (see rfc1846)
    530   Access denied (???a Sendmailism)
    550   Requested action not taken: mailbox unavailable
    551   User not local; please try <forward-path>
    552   Requested mail action aborted: exceeded storage allocation
    553   Requested action not taken: mailbox name not allowed
    554   Transaction failed


