## Intro
[Amazon S3](http://aws.amazon.com/s3/)

I use [S3fs](http://code.google.com/p/s3fs/wiki/FuseOverAmazon) to mount s3 and to make backups from my servers.

## S3 setup

First we have to install some dependencies

    apt-get install s3cmd
    apt-get install build-essential libfuse-dev fuse-emulator-utils libcurl4-openssl-dev libxml2-dev mime-support

Then install s3fs Read the [install instructions](https://code.google.com/p/s3fs/wiki/InstallationNotes)

### To use it

Get an Amazon S3 account! http://aws.amazon.com/s3/

Specify your Security Credentials (Access Key ID & Secret Access Key) by one of the following methods:

Create a [Access Keys (Access Key ID and Secret Access Key)](https://console.aws.amazon.com/iam/home?#security_credential)

Create a file ~/.passwd-s3fs with a AWSACCESSKEYID and AWSSECRETACCESSKEY like:

    accessKeyId:secretAccessKey

Then:

    mkdir /mnt/s3
    /usr/bin/s3fs mybucket /mnt/s3

That's it! the contents of your amazon bucket "mybucket" should now be accessible read/write in /mnt/s3

>Tip: use the option 'use_rss' for [cost savings ;)](http://aws.amazon.com/about-aws/whats-new/2010/05/19/announcing-amazon-s3-reduced-redundancy-storage/) for 99.99% durability . Don't work in fstab.

    /usr/bin/s3fs backup.filmer.nl /mnt/s3/backup -o rw,allow_other,dev,suid,use_rrs

## fstab

    s3fs#mybucket /mnt/s3 fuse allow_other 0 0

## Crontab

Example cron:

    0 8 * * * /usr/bin/rsync --exclude-from=/root/.backup-exclude --bwlimit 100 -aurz --delete --files-from=/root/.backup / /mnt/s3

Example '/root/.backup' file.

    /home/user1
    /home/user2
    /var/lib/mysql

Example '/root/.backup-exclude' file.

    *~
    *Trash-*
