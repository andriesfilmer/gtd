# Other files
* [INSTALL](./INSTALL.md) - Fullstack mailserver
* [INSTALL-outgoing](./INSTALL-outgoing.md) - Only outgoing mailserver
* [DEBUG](./DEBUG.md)
* [Certificates](./certificates.md)

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

