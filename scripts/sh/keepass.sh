#!/bin/sh

# Shell script to open Keepass db without password.
###################################################

# Change path to you Keepass db.
keepass_db="/home/andries/Nextcloud/Private/andries.kdbx"

# Fetch the password from remote server
#--------------------------------------
# Generate a ssh keypair with `ssh-keygen`
# place the public key in 'authorised_keys' on a remote server
keepass_pwd=`ssh server05.filmer.net "cat .ssh/keepass-file"`


# Alternative to fetch the password local
#----------------------------------------
# With keepassxc and Gnome keyring (secret-tool)
# You will need to install libsecret-tools for this to work.
#
# First store your password in an unreadable form, and one needs to be
# logged in as your user to be able to open KeePassXC or read the password.
#
# Enter your keepass password when prompt.
#secret-tool store --label="KeePass Andries" keepass andries
#
# Then lookup the password and pipe it to keepassxc stdin.
#keepass_db =`secret-tool lookup keepass andries | keepassxc --pw-stdin $keepass_db`

# With keepass2 (old method)
#/usr/bin/keepass2 $keepass_db -pw:$keepass_pwd
#----------------------------------------

# With keepassxc and fetched password
echo $keepass_pwd | keepassxc --pw-stdin $keepass_db


