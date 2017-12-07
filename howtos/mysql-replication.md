This howto describes how to setup replication in MySQL 5.0 on Debian Etch

## Master setup

Add this to /etc/mysql/conf.d/filmer.cnf

    server-id               = 1
    log_bin                 = /var/log/mysql/mysql-bin.log
    # WARNING: Using expire_logs_days without bin_log crashes the server! See README.Debian!
    expire_logs_days        = 50
    max_binlog_size         = 100M

restart mysqld
    /etc/init.d/mysql restart

## Slave setup

Add this to /etc/mysql/conf.d/filmer.cnf

    server-id              = 2
    log_bin                 = /var/log/mysql/mysql-bin.log
    # WARNING: Using expire_logs_days without bin_log crashes the server! See README.Debian!
    expire_logs_days        = 50
    max_binlog_size         = 100M

The last three variables are only needed when this server is a master itself, but it doesn't hurt and may become handy when the master has to be replaced by this server.

Now we have to start the replication, do this like described in the next section.

## Start replication (also perform this step when replication is broken)

### On the master

Lock the tables (WARNING: the database will be locked until we come to the UNLOCK TABLES command!)
    mysql> FLUSH TABLES WITH READ LOCK;

Get the current binary logfile and the position. Save the numbers, we need them later!
    mysql> SHOW MASTER STATUS;

Copy contents of the MySQL data directory into a tar file

    cd /var/lib/mysql
    tar -cvf /var/mysql-snapshot.tar --exclude 'mysql_upgrade_info' .

re-enable write activity on the master:
    mysql> UNLOCK TABLES;

Now the master is set up and fully functional again
Copy /tmp/mysql-snapshot.tar to /tmp/ on the slave server
Copy /var/mysql-snapshot.tar to the slave using scp.

### On the slave 

Stop MySQL
    /etc/init.d/mysql stop

Copy the master's data to the MySQL data directory
    cd /var/lib/mysql

Delete all databases
    find . -type d | xargs rm -r

Unpack the snapshop from the location where you copied it to.
    tar -xzvf /var/mysql-snapshot.tar.gz


Edit master.info using the saved variables from the master server.
    14
    mysql-bin.000092
    517263
    mysql.filmer.nl
    replication
    password
    3306
    60
    0

I don't know exactly why, but you have to remove these files:
    rm mysqladmin-replication-relay-bin.*
    rm relay-log.info

Start mysql
    /etc/init.d/mysql start

## Create a backup script 

A MySQL replica is a ideal candidate to make database backups. For a backup the database must be locked, 
on a replica this shouldn't be a problem.

Edit /root/scripts/make-backup-mysql.sh


    #!/bin/sh
    
    if [ ! -d "/var/backups/mysql/" ] ; then
      `mkdir /var/backups/mysql/`
    fi
    
    
    # First delete old mysql-backup
    rm -fR /var/backups/mysql/*
    
    # Copy mysql-database with locking
    for dir in `ls -t /var/lib/mysql/`;
    do
  if [ -d "/var/lib/mysql/$dir" ]
  then
    /usr/bin/mysqlhotcopy --user=root $dir /var/backups/mysql/ > /dev/null
  fi
    done
    
    `/usr/bin/rsync --bwlimit 100 -auz --delete /var/backups/mysql/ mysqladmin-rep@backup.filmer.nl:backup/var/lib/mysql/`
    
    exit 0


Add the script to the crontab

    0 1 * * * /root/scripts/make-backup-mysql.sh
