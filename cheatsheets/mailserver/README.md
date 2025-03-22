# Other files
* [INSTALL](./INSTALL.md)
* [INSTALL-outgoing](./INSTALL-outgoing.md)
* [DEBUG](./DEBUG.md)

## Check postfix configuration

    postfix check

## Mail utils

    apt install mailutils

## Postfix

    postfix check for open relay

## Config

To see all of your configs, type postconf. To see how you differ from the defaults, try postconf -n

    postconf -n

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

