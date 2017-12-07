# NFS with heartbeat and DRBD

This document describes how DRBD, heartbeat and NFS were installed on olifant and neushoorn. For newer versions of DRBD it is recommended not to use a meta disk partition anymore.

## Create partitions

Create one partition bigger than 128 MB on each server, and one big data partition. (note: the >128 MB meta disk is not needed anymore for newer versions of DRBD!)

    apt-get install parted

    parted /dev/sdb
    (parted) mklabel gpt
    (parted) mkpart primary 0 135M
    (parted) mkpart primary 135M 2750G

    mkfs.ext3 /dev/sdb1
    mkfs.ext3 /dev/sdb2

# Install DRBD, heartbeat and NFS

Test

## On both servers

    apt-get install linux-headers-2.6.18-5-amd64 drbd0.7-module-source drbd0.7-utils

    cd /usr/src/
    tar xvfz drbd0.7.tar.gz
    cd modules/drbd/drbd
    make
    make install

Edit /etc/drbd.conf

    resource r0 {

     protocol C;
     incon-degr-cmd "halt -f";

     startup {
        degr-wfc-timeout 120;    # 2 minutes.
     }

     disk {
       on-io-error   detach;
     }

     net {
      }

     syncer {
       rate 100M;
       group 1;
       al-extents 257;
     }

    on olifant {                    # the hostname of server 1 (uname -n)
      device     /dev/drbd0;        #
      disk       /dev/sdb2;         # data partition on server 1
      address    10.0.0.1:7788;     # IP address on server 1
      meta-disk /dev/sdb1[0];       # 128MB partition for DRBD on server 1
     }

    on neushoorn {                  # the hostname of server 2 (uname -n)
      device    /dev/drbd0;         #
      disk      /dev/sdb2;          # data partition on server 2
      address   10.0.0.2:7788;      # IP address on server 2
      meta-disk /dev/sdb1[0];       # 128MB partition for DRBD on server 2
     }
    }


    modprobe drbd
    drbdadm up all

## On primary server

    drbdsetup /dev/drbd0 primary --do-what-I-say
    mkfs.ext3 /dev/drbd0
    drbdadm connect all

## On both servers

    apt-get install nfs-kernel-server nfs-common
    update-rc.d -f nfs-kernel-server remove
    update-rc.d -f nfs-common remove

    apt-get install heartbeat

in /etc/default/nfs-common:

    STATDOPTS="-n olifant_neushoorn"
    NEED_IDMAPD=yes

    echo 'killall -9 nfsd ; exit 0' > /etc/heartbeat/resource.d/killnfsd
    chmod 755 /etc/heartbeat/resource.d/killnfsd

Edit /etc/heartbeat/ha.cf

    auto_failback off
    logfacility     local0
    keepalive 2
    deadtime 5
    serial  /dev/ttyS0
    bcast   eth2
    node olifant neushoorn


Edit /etc/heartbeat/haresources:

    olifant IPaddr::192.168.4.201/24/eth3 drbddisk::r0 Filesystem::/dev/drbd0::/drbd::ext3 killnfsd nfs-kernel-server nfs-common

edit /etc/heartbeat/authkeys

    auth 1
    1 sha1 ditisnietophetbuitennetwerk

    chmod 600 /etc/heartbeat/authkeys

Edit /etc/exports

    /drbd/nfs_exports        192.168.4.0/24(rw,sync,no_subtree_check,fsid=0)
    /drbd/nfs_exports/usr    192.168.4.0/24(rw,sync,no_subtree_check)
    /drbd/nfs_exports/var    192.168.4.0/24(rw,sync,no_subtree_check)
    /drbd/nfs_exports/home   192.168.4.0/24(rw,sync,no_subtree_check)

NFS state information is stored in /var/lib/nfs. When a heartbeat failover happens
this information is missing, and locks may go wrong. We put /var/lib/nfs on the
DRBD device to avoid this problem. (probably you'll have to stop nfs on the primary node first)

    rm -r /var/lib/nfs
    ln -s /drbd/varlibnfs /var/lib/nfs

## On the primary server

    mkdir /drbd/varlibnfs
    mkdir /var/lib/nfs/v4recovery
(the v4recovery directory should exist but is not created automatically)

## Useful commands

### Smooth failover on a primary node

First check if DRBD is consistent:
    cat /proc/drbd

The output should contain a rule like this:
    0: cs:Connected st:Primary/Secondary ld:Consistent

Check for words Primary, Secondary and Consistent. If you don't see these words, DRBD is BROKEN, and you should NOT start a failover!

If DRBD is OK do the actual failover
    /etc/init.d/heartbeat standby

### Test DRBD write speed

    time dd if=/dev/zero of=/drbd/test bs=16k count=16k
    time dd conv=fdatasync if=/dev/zero of=test bs=16k count=64k

### Test DRBD read speed

    tie dd if=/drbd/test of=/dev/null bs=16k

Reload exports (after a change)
    exportfs -rv
