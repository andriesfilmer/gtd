# Other files
* [INSTALL](./INSTALL.md)
* [DEBUG](./DEBUG.md)

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


## Postfix Log Report

Pflogsumm is a great tool to create a summary of Postfix logs. Install it on Ubuntu with:

    sudo apt install pflogsumm
    sudo pflogsumm -d today /var/log/mail.log
    sudo pflogsumm -d yesterday /var/log/mail.log
    sudo pflogsumm /var/log/mail.log # Report for this week.

## Check sites
* Easy DMARC <https://easydmarc.com/tools/dkim-lookup?domain=inzetrooster.nl> dmarc, spf, dkim
* Blacklist check <https://mxtoolbox.com/blacklists.aspx>
* Test the Spammyness of your emails <https://www.mail-tester.com/>

