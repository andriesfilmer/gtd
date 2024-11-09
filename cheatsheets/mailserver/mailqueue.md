# Mail queue

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

## Remove specific emails (i.o email@address)

Remove postqueue **to** email@address mails in queue

    mailq | tail -n +2 | grep -v '^ *(' | awk  'BEGIN { RS = "" } { if ($8 ~ /andries@example.com/ && $9 == "") print $1 }' | tr -d '*!' | postsuper -d -

Remove postqueue **from** email@address mails in queue

    postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /MAILER-DAEMON/ { print $1 }' | tr -d '*!' | postsuper -d -

Remove mails, assumes ID is between 10 and 11 digits, (based on inodes)

    mailq | grep 'email@address' -B1 | grep -oE "^[A-Z0-9]{10,11}" | sudo postsuper -d -

## Transfer queue to other server

Transfer a single queued message to other server, -t mains use headers from postcat file.

    postcat -bhq <message-id> | ssh andries@server08.igroupware.org "sendmail -t -f from-address@domain.com"

You can set in the transport file `/etc/postfix/transport` a line like this:

    * smtp:[new_server_dns_or_ip]

Then do:

    postmap /etc/postfix/transport

Then do postfix reload to load changes.

Then flush the queue with:

    postqueue -f

## Trouble shooting with qshape

When mail is draining slowly or the queue is unexpectedly large, run qshape(1) as the super-user (root) to help zero in on the problem

For example:

    qshape -s deferred | head

More: <http://www.postfix.org/QSHAPE_README.html>

## Query the logfile

Get top 10 mails send from addresses

    #cat /var/log/mail.log | grep 'from=' | awk '{print $7}' | sort | uniq -c | sort -nr | head
    cat /var/log/mail.log | grep -o -P 'from=<(.+?)>' | sort | uniq -c | sort -nr | head

Find hard bounces

    grep " dsn=5." /var/log/mail.log | grep -o -P " to=<(.+?)>" | sort | uniq -c

See how many mails are blocked

    cat /var/log/mail.log | grep 'listed by domain' | awk '{print $11}' | sort | uniq -c

Who is polluting the logfile: NOQUEUE: reject: RCPT from unknown

    cat /var/log/mail.log | grep 'NOQUEUE: reject:' | awk '{print $10 " " $17}' | sort | uniq -c | sort -nr | head
    cat /var/log/mail.log | grep -o -P 'unknown(\[.+?\])' | sort | uniq -c | sort -nr | head

Checking postscreen ranking

    cat /var/log/mail.log | grep 'DNSBL rank'


## Deliver e-mail to an alternate address

### Find the mail ID in postfix

You need to find the mail ID of the mail you want to send to a different address.

    $ postqueue  -p | grep 'm@ttias.be' -B 2 | grep 'keyword'
    CF452C1239FB    28177 Tue Aug  2 14:52:38  thesender@domain.tld

### Mark the postfix queue item as ‘on hold’

To prevent Postfix from trying to deliver it in the meanwhile.

    $ postsuper -h CF452C1239FB
    postsuper: CF452C1239FB: placed on hold
    postsuper: Placed on hold: 1 message

### Extract the mail from the queue

Extract that email and save it to a temporary file. If you’re paranoid, don’t save to /tmp as everyone can read that mail while it’s there.

    $ postcat -qbh CF452C1239FB > /tmp/m.eml

### Send queued mail to different recipient

Now that you’ve extracted that e-mail, you can have it be sent to a different recipient than the original.

    $ sendmail -f thesender@domain.tld newrecipient@domain.tld < /tmp/m.eml

#### Delete the ‘on hold’ mail from the postfix queue

    $ postsuper -d  CF452C1239FB
    $ rm -f /tmp/m.eml

Resource: [Mattias Geniar](https://ma.ttias.be/postfix-mail-queue-deliver-e-mail-alternate-address/)
