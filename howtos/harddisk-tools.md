# Harddisk - tools

## Harddisk clone
Clone your entire disk, all partitions, byte for byte, using the dd command. The replacement drive will be a turn-key, plug-in replacement for the original drive. Drive ''sdb'' has to be bigger!

    dd if=/dev/sda of=/dev/sdb bs=32768

The ''bs=32256'' represents one complete track of 63 sectors each with 512 bytes. This is about the optimum in my experience with the hardware I have. Omitting the bs parameter will cause dd to default to 512 bytes in each transfer and can slow down the process significantly.

## List Partions

    sudo parted /dev/sdc print
    sudo sfdisk -l -uS
    sudo gdisk -l /dev/sdc

## Partition clone

    sudo dd if=/dev/sda1 of=/dev/sdb1

If this partition is the boot partition we need to tell this to grub.

    sudo grub

Grub will launch and give you the grub> prompt. Here, type:

    find /boot/grub/stage1

You should see something come back that looks like hd(0,0). Jot that down, you’ll need it in a second.

Now, still in the grub> prompt, type:

    root hd(0,0)

You’ll put in whatever result you go above – it may be different than hd(0,0). Once that completes, type:

    setup (hd0)

Even if you got a result that differs from hd(0,0) above. Type:

    quit

And you’re out of grub. Restart your machine, removing the LiveCD and you should be up and running on your new hard drive. You may also encounter a problem on your first boot where the system will try to scan your hard drive for bad sectors. If that fails, you’ll find yourself in a root terminal session. Just type:

    fsck

* more info: <http://www.arsgeek.com/2008/01/22/how-to-clone-your-bootable-ubuntu-install-to-another-drive/>

## udisks

If you use a desktop with a docking bay and  don't want to use fstab, you can use udisks to mount or unmount devices or disks.
The UUID method is the most stable one as other ID methods can change if you rename your label for example.

    udisks --mount /dev/disk/by-uuid/70439c63-de2c-4319-a832-0dee5ea05fc5

I use this in crontab en mount the disk just voor the night during backup for my remote servers.

## mdadm

    sudo mdadm --assemble --scan

## cryptsetup

 `sudo apt-get install cryptsetup`

In this example we use `sda1` which is created with the GUI disk utility -> 'luks + ext4')
Only after creating a new disk use one:

    /sbin/cryptsetup luksAddKey /dev/sda1 /tmp/backup-key-file
    /sbin/cryptsetup luksAddKey /dev/disk/by-uuid/247ad289-dbe5-4419-9965-e3cd30f0b080 /tmp/backup-key-file

To unlock and lock a LUKS partition

    /sbin/cryptsetup luksOpen /dev/sda1 backup --key-file=/tmp/backup-key-file
    /sbin/cryptsetup luksOpen /dev/disk/by-uuid/247ad289-dbe5-4419-9965-e3cd30f0b080 backup --key-file=/tmp/backup-key-file
    /bin/mount /dev/mapper/backup /mnt/backup # Not needed anymore?
    -
    /bin/umount /mnt/backup # Not needed anymore?
    /sbin/cryptsetup luksClose backup

## Shred - Erase harddisk

Overwrite the specified device/file repeatedly, in order to make it harder for even very expensive hardware probing to recover the data.
Start the server with an Ubuntu Server CD and choose for a live/try Ubuntu.

Open a Terminal and type:

    shred -fuvz -n 3 /dev/{device}

*f: (force) change permissions to allow writing if necessary<br>
*u: (remove)Â truncate and remove file after overwriting
*v: (verbose) show progress<br>
*n: (iterations) Overwrite N times instead of the default (25)

;NOTE: Be aware that the data is definitely lost after running this command!
