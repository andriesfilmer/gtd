#!/bin/sh

# Backup on remote disk created with cryptsetup
#----------------------------------------------
# - Creating a new LUKS encrypted partition with GUI Disk Utility
#   and label this partition as `PARTITIONLABEL`.
# - cryptsetup must be installed on remote `SERVER`.
# - sshd on `SERVER` must allow root loging (i.o. AllowRootLogin)

SERVER='rsync@backup.filmer.net'
HOST='server01'
FILESTOBACKUP='/root/.backup-script/files'
KEYFILE='/root/.backup-script/key-file'
PARTITIONDEVICE='/dev/disk/by-uuid/c22b5cec-95e5-4fb5-bb73-113b02b73828'
PARTITIONLABEL='backup'
MAILMSG='/root/.backup-script/mail'
MAILADDRESS='andries@filmer.nl'
TMPKEYFILE='.key-file'

# Debug
#ssh -o ConnectTimeout=3 84.106.235.36 2>/dev/null; (($? == 127)) && echo 'something broke.' >&2
###############################################################################

ssh -o ConnectTimeout=5 $SERVER "exit" >/dev/null
if [ $? -eq 255 ]; then # connection timeout status 255
    echo "SSH connection timeout"
    /usr/sbin/sendmail -f "ssh-connection-timeout@$SERVER" $MAILADDRESS < $MAILMSG
    exit 1
fi

scp $KEYFILE $SERVER:$TMPKEYFILE >/dev/null 2>&1 && \
  ssh $SERVER "sudo /sbin/cryptsetup luksOpen $PARTITIONDEVICE $PARTITIONLABEL --key-file=$TMPKEYFILE" && \
  ssh $SERVER "/usr/bin/shred -u $TMPKEYFILE"

if [ $? -ne 0 ]; then
    echo "Crypt setup failed."
    /usr/sbin/sendmail -f "cryptsetup-failed@$SERVER" $MAILADDRESS < $MAILMSG
    exit 1
fi

ssh $SERVER "sudo /bin/mount /dev/mapper/$PARTITIONLABEL /mnt/$PARTITIONLABEL"
if [ $? -ne 0 ]; then
    echo "mount failed."
    /usr/sbin/sendmail -f "mount-failed@$SERVER" $MAILADDRESS < $MAILMSG
    exit 1
fi

# Only directories
#/usr/bin/rsync -av --include='*/' --exclude='*' \

/usr/bin/rsync -aur --delete --delete-excluded --sparse \
  --exclude-from=/root/.backup-script/exclude \
  --files-from=$FILESTOBACKUP / $SERVER:/mnt/backup/$HOST/

ssh $SERVER "sudo /bin/umount /mnt/backup && sudo /sbin/cryptsetup luksClose backup"
if [ $? -ne 0 ]; then
    echo "umount failed."
    /usr/sbin/sendmail -f "umount-failed@$SERVER" $MAILADDRESS < $MAILMSG
    exit 1
fi

# Set timestamp for last backup
/usr/bin/touch /root/.backup-script/timestamp
if [ $? -eq 0 ]; then
    #/usr/sbin/sendmail -f "backup-success@$SERVER" $MAILADDRESS < $MAILMSG
    exit 1
fi


