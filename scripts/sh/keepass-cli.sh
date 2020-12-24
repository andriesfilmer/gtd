#!/bin/bash

entry="$1"
keepass_pwd=`ssh server05.filmer.net "cat .ssh/keepass-file"`
keepass_db="/home/andries/Nextcloud/Private/andries.kdbx"
keepass_dir="Andries"

if [ -z $2 ]; then keepass_dir='Andries'; else keepass_dir=$2; fi

echo "Connecting to Keepass database..."

function get_creds {
  expect <<- DONE
     set timeout 4
     spawn kpcli
     match_max 100000000
     expect  "kpcli:/>"
     send    "open $keepass_db\n"
     sleep 0.5
     expect  "password:"
     send    "$keepass_pwd\n"
     expect  ">"
     send    "find '$entry'\n"
     sleep 0.5
     send    "y"
     expect  ">"
DONE

}

credentials=$(get_creds)

#echo "$credentials"
echo "$credentials" | grep 'matches' | awk '{print $2 " " $3 " " $4}'
echo ""
echo "$credentials" | grep 'Title:\|Pass:\|Notes:\|Uname:\|URL:'


