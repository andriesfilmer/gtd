## Testing SMTP servers

## Links

* [BLACKLIST CHECK](https://mxtoolbox.com/blacklists.aspx)

## Mail tester

Test the Spammyness of your emails <https://www.mail-tester.com/>

## Swaks - SMTP transaction tester

    sudo apt install swaks

Simple test

    swaks --from andries@inzetrooster.nl --to=andries.filmer@gmail.com --server=server03.filmer.net
    swaks -t andries.filmer@gmail.com -f andries@filmer.nl -a -tls -au andries@filmer.nl -ap "mypasswd" -s mail.filmer.nl:587


## Traditional mail debug
\> client input
< server response

### Debug smtp

    telnet localhost 25

    < 220 smtp.example.com ESMTP Sendmail 8.9.2/8.9.2/Debian/GNU; Sat, 9 Jun 2001 12:27:28 +0100 (BST)
    > HELO user123.example.com
    < 250 smtp.example.com Hello user123.example.com [10.0.0.100], pleased to meet you
    > MAIL FROM: user123@example.com
    < 250 user123@example.com Sender ok
    > RCPT TO: test@example.com
    < 250 test@example.com Recipient ok
    > DATA
    < 354 Enter mail, end with "." on a line by itself
    > Hello
    >.

With auth login, first base64 string

    perl -e 'use MIME::Base64; print encode_base64("andries\@gnoom.nl");'

output: YW5kcmllc0Bnbm9vbS5ubA

Second base64 string

    perl -e 'use MIME::Base64; print encode_base64("test");'

output: dGVzdA

    telnet localhost 25

    < Connected to mail.filmer.nl.
    < Escape character is '^]'.
    < 220 mail.filmer.nl ESMTP
    > auth login
    < 334 VXNlcm5hbWU6
    > YW5kcmllc0Bnbm9vbS5ubA
    < 334 UGFzc3dvcmQ6
    > dGVzdA
    < 235 ok, go ahead (#2.0.0)
    > MAIL FROM: user123@example.com
    < 250 user123@example.com Sender ok
    > RCPT TO: test@example.com
    < 250 test@example.com Recipient ok
    > DATA
    < 354 Enter mail, end with "." on a line by itself
    > Hello
    >.

To a qmail server. With auth login

    telnet localhost 25

    < Connected to mail.filmer.nl.
    < Escape character is '^]'.
    < 220 mail.filmer.nl ESMTP
    > auth login
    < 334 VXNlcm5hbWU6
    > YW5kcmllc0BtYWRyaWQubmV0ZXhwby5ubA
    < 334 UGFzc3dvcmQ6
    > a2lraTEzMTM
    < 235 ok, go ahead (#2.0.0)
    > MAIL FROM: user123@example.com
    < 250 user123@example.com Sender ok
    > RCPT TO: test@example.com
    < 250 test@example.com Recipient ok
    > DATA
    < 354 Enter mail, end with "." on a line by itself
    > Hello
    >.
    >quit


Without auth login

    telnet localhost 25

    < Trying 62.250.10.138...
    < Connected to mars.soctek.nl.
    < Escape character is '^]'.
    < 220 mars.soctek.nl ESMTP
    > helo andries@filmer.nl
    < 250 mars.soctek.nl
    > mail
    < 250 ok
    > rcpt to:andries@test.soctek.nl
    < 250 ok
    > data
    < 354 go ahead
    >
    > This is a test
    > .
    > quit

### Debug pop3
\> client input
< server response

    telnet localhost 110

    < Trying 127.0.0.1...
    < Connected to localhost.localdomain.
    < Escape character is '^]'.
    < +OK Hello there.
    > user user@example.com
    < +OK Password required.
    > pass [password]
    < +OK logged in.
    > stat
    < +OK 5 441227
    > list
    < +OK 5 messages
    > retr 1
    < --- message 1 ---
    > DELE 1
    < +OK
    > quit
    < +OK Bye-bye.
    < Connection closed by foreign host.


### Debug imap
\> client input
< server response

    telnet localhost 143

    < Trying 127.0.0.1...
    < Connected to localhost.localdomain.
    < Escape character is '^]'.
    < * OK Courier-IMAP ready. Copyright 1998-2001 Double Precision, Inc. See COPYING for distribution information.
    > a001 login user@example.com [password]
    < a001 OK LOGIN Ok.
    < a001 examine inbox
    > a001 logout
    < * BYE Courier-IMAP server shutting down
    < a001 OK LOGOUT completed
    < Connection closed by foreign host.

* [IMAP protocol version 4 - rfc](https://tools.ietf.org/html/rfc1730)

## Dovecot

As a general tip for debug the config if dovecot is not starting

    dovecot -F


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
    577   You don't have permission to send to the recipient

## Config

List non default configuration

    postconf -n
