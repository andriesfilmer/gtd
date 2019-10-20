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

First create a partition with `fdisk`. In this example we use `sda1`.
You can use the GUI disk utility to create a -> 'luks + ext4') partition or:

    cryptsetup -y -v luksFormat /dev/sda1

Enter passphrase twice. Then make a file system:

    mkfs.ext4 /dev/mapper/backup

Add a key (password in `backup-key-file`):

    cryptsetup luksAddKey /dev/sda1 /tmp/backup-key-file
    cryptsetup luksAddKey /dev/disk/by-uuid/247ad289-dbe5-4419-9965-e3cd30f0b080 /tmp/backup-key-file

To unlock and lock a LUKS partition

    cryptsetup luksOpen /dev/sda1 backup --key-file=/tmp/backup-key-file
    cryptsetup luksOpen /dev/disk/by-uuid/247ad289-dbe5-4419-9965-e3cd30f0b080 backup --key-file=/tmp/backup-key-file
    mount /dev/mapper/backup /mnt/backup
    -
    umount /mnt/backup
    cryptsetup luksClose backup

See how many slots are taken:

    cryptsetup luksDump /dev/sda1
    cryptsetup luksRemoveKey /dev/sda1


## Shred - Erase harddisk

Overwrite the specified device/file repeatedly, in order to make it harder for even very expensive hardware probing to recover the data.
Start the server with an Ubuntu Server CD and choose for a live/try Ubuntu.

Open a Terminal and type:

    shred -fuvz -n 3 /dev/{device}

*f: (force) change permissions to allow writing if necessary<br>
*u: (remove)Â truncate and remove file after overwriting
*v: (verbose) show progress<br>
*n: (iterations) Overwrite N times instead of the default (25)

NOTE: Be aware that the data is definitely lost after running this command!

## Check harddisk for bad sectors

### badblocks

    sudo fdisk -l
    sudo badblocks -v /dev/sda > ~/badsectors.txt  # read only mode
    sudo badblocks -vn /dev/sda > ~/badsectors.txt # read/write mode

Use fsck command to tell Ubuntu not to use the bad sectors mentioned in the badsectors.txt file. That way life of the hard disk is increased a bit until you get a new one for replacement.

    sudo fsck -l ~/badsectors.txt /dev/sda

### smartctl

You need smartmontools.

    sudo apt install smartmontools

The commands for the various tests are (replace sdX with the drive that you want to test)

* Short: `sudo smartctl -t short /dev/sdX`
* Long: `sudo smartctl -t long /dev/sdX`
* Conveyance: `sudo smartctl -t conveyance /dev/sdX`

Note: You will not get any scrolling output for your test beyond being told how long the test will take.
If you're running the long test, you may have to wait an hour or two or longer.

Once the test is finished, it's time to get out result!

    sudo smartctl -H /dev/sdX

The result above indicates that your hard disk is healthy, and may not experience hardware failures any soon.

    == START OF READ SMART DATA SECTION ===
    SMART overall-health self-assessment test result: PASSED


