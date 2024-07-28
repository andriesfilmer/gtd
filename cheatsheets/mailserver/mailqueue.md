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

