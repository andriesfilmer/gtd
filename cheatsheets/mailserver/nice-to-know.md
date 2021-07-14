# Nice to know for Postfix


## Transport to other mailserver

You can set in the transport file /etc/postfix/transport a line like this:

    * smtp:[new_server_dns_or_ip]

Then do:

    postmap /etc/postfix/transport

Then do postfix reload to load changes.

Then flush the queue with:

    postqueue -f

If instead of setting * you set a domain name, only mails to this domain will be redirected to the new server.


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
