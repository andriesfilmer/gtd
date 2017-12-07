#!/bin/sh

if [ $(ps -e -o uid,cmd | grep $UID | grep node | grep -v grep | wc -l | tr -s "\n") -eq 0 ]
then
        export NODE_ENV=production
        forever start --sourceDir /var/www/pim.filmer.nl/current/api api.js >> /var/log/node/api.filmer.nl.txt 2>&1
fi
