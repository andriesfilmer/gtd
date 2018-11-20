#!/bin/bash
### From http://jasonschaefer.com, modified by Karibu (http://freedif.org)
### https://freedif.org/improve-spamassassin-accuracy-sa-learn-and-spam-trap

# Specify users names, space padded [user=(user1 user2 user3)] or leave it empty [user=()] to include all users. All users is considered uid ≥ 1000.
user=(vmail)

# Specify Spam Trap user name (Comment out to disable spamtrap)
spamtrap=spam

# After how many days should Spam be deleted?
cleanafter=90

# Backup path (Comment out to disable backup)
bk=/var/backups/sa-learn_bayes_`date +%F`.backup

# Log file to keep record
log=/var/log/sa-learn.log

####### BEGINNING OF THE SCRIPT ########

echo -e "\n`date +%c`"  >> $log 2>&1

if [ -z ${user[@]} ]; then
echo No user mentioned - Using all users from system
user=( $(awk -v exclude="$spamtrap" -F':' '$3 >= 1000 && $3 < 65534 && $1!~ exclude{print $1}' /etc/passwd) )
fi

for u in ${user[@]}; do
if [ ! -d /home/vmail/$d/$u/Maildir ]; then
echo "No such Maildir for $u" >> $log 2>&1
else
echo "Proceeding with ham and spam training on user \"$u\""

echo $u Spam Scan>> $log 2>&1
sa-learn --no-sync --spam /home/vmail/$d/$u/Maildir/.Spam/{cur,new} >> $log 2>&1

echo $u Ham Scan>> $log 2>&1
sa-learn --no-sync --ham /home/vmail/$d/$u/Maildir/{cur,new} >> $log 2>&1
fi
done

if [ -n $spamtrap ]; then
echo SpamTrap Scan>> $log 2>&1
sa-learn --no-sync --spam /home/vmail/$d/$spamtrap/Maildir/.Spam/{cur,new} >> $log 2>&1
sa-learn --no-sync --spam /home/vmail/$d/$spamtrap/Maildir/{cur,new} >> $log 2>&1
fi
echo Sync SA base >> $log 2>&1
sa-learn --sync >> $log 2>&1
if [ $? -eq 0 ]; then
for u in ${user[@]}; do
echo "deleting spam for $u older than $cleanafter" >> $log 2>&1
find /home/vmail/$d/$u/Maildir/.Spam/cur/ -type f -mtime +$cleanafter -exec rm {} \;
done
else
echo "sa-learn wasn't able to sync. Something is broken. Skipping spam cleanup"
fi

echo "Statistics:" >> $log 2>&1
sa-learn --dump magic >> $log 2>&1
echo ============================== >> $log 2>&1

if [ -n $bk ]; then
echo "Backup writing to $bk" >> $log 2>&1
sa-learn --backup > $bk
fi
