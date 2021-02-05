# imapsync

Email IMAP tool for syncing, copying, migrating and archiving email mailboxes
between two imap servers, one way, and without duplicates.

* <https://github.com/imapsync/imapsync>

    git clone https://github.com/imapsync/imapsync.git

## Install

This command installs standard Ubuntu packages:

    sudo apt-get install  \
    libauthen-ntlm-perl     \
    libclass-load-perl      \
    libcrypt-ssleay-perl    \
    libdata-uniqid-perl     \
    libdigest-hmac-perl     \
    libdist-checkconflicts-perl \
    libencode-imaputf7-perl     \
    libfile-copy-recursive-perl \
    libfile-tail-perl       \
    libio-compress-perl     \
    libio-socket-inet6-perl \
    libio-socket-ssl-perl   \
    libio-tee-perl          \
    libmail-imapclient-perl \
    libmodule-scandeps-perl \
    libnet-dbus-perl        \
    libnet-ssleay-perl      \
    libpar-packer-perl      \
    libreadonly-perl        \
    libregexp-common-perl   \
    libsys-meminfo-perl     \
    libterm-readkey-perl    \
    libtest-fatal-perl      \
    libtest-mock-guard-perl \
    libtest-mockobject-perl \
    libtest-pod-perl        \
    libtest-requires-perl   \
    libtest-simple-perl     \
    libunicode-string-perl  \
    liburi-perl             \
    libtest-nowarnings-perl \
    libtest-deep-perl       \
    libtest-warn-perl       \
    make                    \

* <https://imapsync.lamiral.info/INSTALL.d/INSTALL.Ubuntu.txt>

## Perl

Imapsync works under any Unix with Perl.

    sudo install cpanminus

In case you want to update the Perl module Mail::IMAPClient, a major module for imapsync, the following command installs it "manually":

    sudo cpanm Mail::IMAPClient


## USAGE

    imapsync \
     --host1 test1.lamiral.info --user1 test1 --password1 secret1 \
     --host2 test2.lamiral.info --user2 test2 --password2 secret2
