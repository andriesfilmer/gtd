#!/bin/sh

# Generate a ssh keypair with `ssh-keygen`
# place the public key in 'authorised_keys' on a remote server

# Change remote server and path to you Keepass db.
#
keepass_pwd=`ssh server05.filmer.net "cat .ssh/keepass-file"`
keepass_db="/home/andries/Nextcloud/Private/andries.kdbx"

/usr/bin/keepass2 $keepass_db -pw:$keepass_pwd
