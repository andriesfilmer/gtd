#!/bin/sh

# Shell script to copy a entry password without master password.
################################################################

keepass_pwd=`ssh server05.filmer.net "cat .ssh/keepass-file"`
keepass_db="/home/andries/Nextcloud/Private/andries.kdbx"
keepass_dir="Andries"

if [ -z $2 ]; then clicom='clip'; else clicom=$2; fi

echo "Connecting to Keepass database..."
echo $keepass_pwd | keepassxc-cli $clicom ~/Nextcloud/Private/andries.kdbx $keepass_dir/$1
