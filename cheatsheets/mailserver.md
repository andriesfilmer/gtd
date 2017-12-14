# Mailserver cheatsheet

## Services

Check if these services are running: 

    netstat -lnptu

## Postfix queue

View postfix queue

    postqueue -p

Retry sending of all messages in queue

    postqueue -f

Empty postfix queue

    postsuper -d ALL

Remove specific emails (i.o. andriesfilmer@hotmail.com)

    mailq | tail -n +2 | grep -v '^ *(' | awk  'BEGIN { RS = "" } \
    { if ($7 == "andriesfilmer@hotmail.com" && $9 == "") print $1 } ' \
    | tr -d '*!' | postsuper -d -

To view a message with the ID XXXXXXX

    postcat -vq XXXXXXXXXX


## Logfile

Get ipnrs sorted by connection

    cat /var/log/mail.log | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq -c | sort -n

Very useful logscan script

[PSLOGSCAN](http://archive.mgm51.com/sources/pslogscan.html)


## Dovecot

As a general tip for debug the config if dovecot is not starting

    dovecot -F


## SPF

    dig domainname.ext txt

* [Toolbox spf](https://mxtoolbox.com/spf.aspx)

