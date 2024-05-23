# Other files
* [My mailserver install](./INSTALL.md)
* [Traditional testing](./debug.md)

## Handy checks
* Blacklist check <https://mxtoolbox.com/blacklists.aspx>
* Test the Spammyness of your emails <https://www.mail-tester.com/>

## Check postfix configuration

    postfix check

To see all of your configs, type postconf. To see how you differ from the defaults, try postconf -n

    postconf -n

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

### Remove specific emails (i.o. andries@example.com)

With tail-grep-awk

    mailq | tail -n +2 | grep -v '^ *(' | awk  'BEGIN { RS = "" } { if ($8 ~ /andries@example.com/ && $9 == "") print $1 }' | tr -d '*!' | postsuper -d -

or postqueue-tail-awk (MAILER-DAEMON)

    postqueue -p | tail -n +2 | awk 'BEGIN { RS = "" } /MAILER-DAEMON/ { print $1 }' | tr -d '*!' | postsuper -d -

or grep solution assumes ID is between 10 and 11 digits, (based on inodes)

    mailq | grep 'andries@example.com' -B1 | grep -oE "^[A-Z0-9]{10,11}" | sudo postsuper -d -


## Postfix Log Report

Pflogsumm is a great tool to create a summary of Postfix logs. Install it on Ubuntu with:

    sudo apt install pflogsumm
    sudo pflogsumm -d today /var/log/mail.log
    sudo pflogsumm -d yesterday /var/log/mail.log
    sudo pflogsumm /var/log/mail.log # Report for this week.

