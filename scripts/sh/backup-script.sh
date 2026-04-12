#!/bin/sh

# Backup on remote disk created with cryptsetup
#----------------------------------------------
# - Creating a new LUKS encrypted partition with GUI Disk Utility
#   and label this partition as `PARTITIONLABEL`.
# - cryptsetup must be installed on remote `SERVER`.
# - sshd on `SERVER` must allow root loging (i.o. AllowRootLogin)

SERVER='rsync@backup.filmer.nl'
HOST='server07'
PARTITIONDEVICE='/dev/disk/by-uuid/cee363c4-36b1-43c0-afb8-d2e67eae201b'
PARTITIONLABEL='backup3'
MAILMSG='/root/.backup-script/mail'
MAILADDRESS='andries@filmer.nl'
KEYFILE='/root/.backup-script/key-file'
TMPKEYFILE='/home/rsync/.key-file'

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

/usr/bin/rsync -aurv --delete --delete-excluded --sparse \
  --exclude-from=/root/.backup-script/exclude \
  --files-from=/root/.backup-script/files / $SERVER:/mnt/$PARTITIONLABEL/$HOST/

ssh $SERVER "sudo /bin/umount /mnt/$PARTITIONLABEL && sudo /sbin/cryptsetup luksClose $PARTITIONLABEL"
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
