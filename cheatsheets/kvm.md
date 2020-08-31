- [Kernelbased Virtual Machine (KVM)](#kernelbased-virtual-machine-kvm)
  * [CPU support](#cpu-support)
  * [Install](#install)
  * [Networking](#networking)
  * [Create a KVM image](#create-a-kvm-image)
  * [Start KVM on server](#start-kvm-on-server)
  * [Connect to your remote KVM with VNC](#connect-to-your-remote-kvm-with-vnc)
  * [VNC and MS windows](#vnc-and-ms-windows)
  * [Resize qemu image](#resize-qemu-image)
  * [Mount partition inside qemu image](#mount-partition-inside-qemu-image)
  * [Start KVM from a liveCD](#start-kvm-from-a-livecd)
  * [Create a KVM from a template image](#create-a-kvm-from-a-template-image)
  * [iptables](#iptables)
  * [Resources](#resources)

<!-- END TOC -->

# Kernelbased Virtual Machine (KVM)

On this page I explain how to install en use Kernel Based Machine (KVM) on Ubuntu Server 9.04 (Jaunty).
I don't use the extra layer [libvirt](http://libvirt.org)  and prefer to start kvm on the shell.

## CPU support

You need to find out if your CPU has virtualization support and whether it is turned on. Support may be turned off in your BIOS.
Running the command below appropriate for your CPU manufacturer will produce output if KVM support is found:

    egrep '^flags.*(vmx|svm)' /proc/cpuinfo

## Install
Install the packages for kvm

    sudo apt-get install kvm python-vm-builder

## Networking
To setup a bridge interface, edit /etc/network/interfaces and either comment or replace the existing config with
(replace with the values for your network):

    auto lo
    iface lo inet loopback

    auto eth0
    iface eth0 inet manual

    auto br0
    iface br0 inet static
           address 192.168.0.10
           network 192.168.0.0
           netmask 255.255.255.0
           broadcast 192.168.0.255
           gateway 192.168.0.1
           bridge_ports eth0
           bridge_stp off
           bridge_fd 0
           bridge_maxwait 0

## Create a KVM image

Create a directory that will contain the kvm images

    mkdir /var/kvm_images
    cd /var/kvm_images

Create a file named 'partfile' with the partitions we want (a new disk starts on a line with '---'):

    root 2000
    swap 512
    /tmp 512
    ---
    /home 10000

Create a file 'kvm-template' with you params.

    vmbuilder kvm ubuntu
                     --suite lucid
                     --flavour virtual
                     --domain kvm01
                     --dest kvm01
                     --arch i386
                     --hostname kvm01.filmer.nl
                     --mem 512
                     --user andries
                     --pass mypass
                     --ip 194.242.19.101
                     --mask 255.255.255.0
                     --net 194.242.19.0
                     --bcast 194.242.19.255
                     --gw 194.242.18.1
                     --dns 194.242.18.194
                     --mirror http://nl.archive.ubuntu.com/ubuntu
                     --components main,universe,restricted
                     --addpkg openssh-server
                     --addpkg vim
                     --addpkg language-pack-en
                     --addpkg language-pack-nl
                     --part /var/kvm_images/kvm/kvm-partfile
                     --verbose;

If you want to use libvirt add this line to.

                     --libvirt qemu:///system ;

Create a kvm.

    sh < kvm-template

## Start KVM on server

First check if the ''/etc/kvm/kvm-ifup_br0'' exists.

    #!/bin/sh

    sudo /sbin/ifconfig $1 0.0.0.0 up
    sudo /usr/sbin/brctl addif br0 $1
    exit 0

Start command (Remerber to change the ''name,file,tap,macaddr,vnc:port'') for each virtual machine.

    /usr/bin/kvm
    -M pc
    -m 512
    -smp 1
    -name vm01.filmer.nl
    -monitor pty
    -drive file=/var/kvm_images/vm01/disk0.qcow2,if=ide,index=0,boot=on
    -drive file=/var/kvm_images/vm01/disk1.qcow2,if=ide,index=1
    -net nic,vlan=0,macaddr=52:54:00:99:00:01
    -net tap,vlan=0,ifname=tap101_br0,script=/etc/kvm/kvm-ifup_br0
    -vnc 127.0.0.1:1;

## Connect to your remote KVM with VNC

    sudo apt-get install vncviewer

By default KVM also starts a VNC server on 127.0.0.1. An SSH tunnel can be used to connect to this VNC server safely (encrypted).
Give this command on your local system (your desktop PC) to the ''kvm-host'' server.

    ssh -L 5900:127.0.0.1:5900 kvm-host.filmer.nl

After logging in you can connect to 127.0.0.1:5900 with VNC viewer.<br>
''use vnc:port +5900 from the start command io 5901 for vm01''

## VNC and MS windows

Make al local connection to the server with the windows kvm image.

    ssh -L 5900:127.0.0.1:5900 kvm-host.filmer.nl

Start the kvm image on de host without a network, it creates a NAT network bij default.

    /usr/bin/kvm -M pc -m 1024 -smp 1 -monitor pty -drive file=/var/kvm_images/vista/vista-1.img,if=ide,boot=on -usb -vnc 127.0.0.1

Connect with terminal server to localhost:5900

;VNC mouse pointer cap

The vncserver included in qemu has a irritating drawback. There's a gap between the real mouse pointer and the vnc mouse pointer.
You can use the "-usbdevice tablet" option to avoid this unpleasant effect.

## Resize qemu image

On the host stop the KVM guest. Copy the qcow2 image into a raw image:

    cd /var/kvm_images/<kvm_name>
    qemu-img convert root.qcow2 -O raw root.raw

The raw image can be grown to the desired size (in the example 16GB)

    dd bs=1 if=/dev/zero of=root.raw seek=16G count=0

Now we have increased the image size, but the partitions are still the old small size.
The easiest way to resize the partitions is by using the GParted live CD. Download the [http://gparted.sourceforge.net/livecd.php iso image] and start KVM with the CD image and the disk image, booting from CD:

    /usr/bin/kvm -M pc -m 1536 -monitor pty -no-acpi -cdrom /root/gparted-live-0.3.9-4.iso
    -drive file=/var/kvm_images/webserver.customer/root.raw,if=ide -usb -usbdevice tablet -vnc 192.168.2.230:0 -boot d

Now start the KVM guest and resize the partitions using GParted. If you add partitions don't forget
to change /etc/fstab on the disk. To do so you will need to look up the UUID of the new partition:

    vol_id -u device

When finished stop the KVM client. Backup the unchanged qcow2 image and convert the raw image to the new qcow2 image

    mv root.qcow2 root.qcow2.bak
    qemu-img convert root.raw -O qcow2 root.qcow2

libvirt has to be restarted, otherwise the new kvm won't load (which is a bit strange, by the way).

    /etc/init.d/libvirt-bin restart

Maybe this is also enough, but test it first:

    /etc/init.d/libvirt-bin reload

The new KVM image can now be started with virsh.

## Mount partition inside qemu image

Create the devices /dev/ndb*

    modprobe nbd max_part=8
    kvm-nbd -c /dev/nbd0 /path/to/image
    mount /dev/nbd0p1 /mnt
    umount /mnt
    kvm-nbd -d /dev/nbd0

Now you also fdisk

    modprobe nbd max_part=8
    kvm-nbd -c /dev/nbd0 /path/to/image
    fdisk /dev/nbd0p1

## Start KVM from a liveCD

You may want to start KVM from a liveCD when you messed up the network and cannot login. Use a command like:

    /usr/bin/kvm -M pc -m 1536 -smp 1 -monitor pty -no-acpi -cdrom /root/gparted-live-0.3.9-4.iso
    -drive file=/var/kvm_images/webserver.customer/root.qcow2,if=ide -net nic,macaddr=52:54:00:44:a8:80,vlan=0,model=virtio
    -net tap,fd=8,script=,vlan=0 -usb -vnc 192.168.2.230:0 -boot d

Replace the macaddr with the 'real' mac address of the kvm, to be safe.

## Create a KVM from a template image

When creating a KVM from an existing image don't forget these steps:

* Mount the root image on /mnt (see above)
* Change IP address(es) in /mnt/etc/network/interfaces
* Change the hostname in /mnt/etc/hostname and /etc/hosts
* Create new ssh keys

    ssh-keygen -f /mnt/etc/ssh/ssh_host_rsa_key -N '' -t rsa
    ssh-keygen -f /mnt/etc/ssh/ssh_host_dsa_key -N '' -t dsa

## iptables

With public ipaddressen and bridging I test with: (not finished yet)

    iptables -A FORWARD -i anywhere -o anywhere -j ACCEPT

## Resources

* [help.ubuntu.com/community/KVM/](https://help.ubuntu.com/community/KVM/)
* [help.ubuntu.com/community/JeOSVMBuilder](https://help.ubuntu.com/community/JeOSVMBuilder)
* [virt-tools.org/learning/](http://virt-tools.org/learning/)

**Keep watching these**

* [Docker](https://www.docker.com/) open platform for building, shipping and running distributed applications
* [LXC Linux containers](https://linuxcontainers.org/) virtualization environment for running multiple isolated Linux systems (containers)
* [Apache Cloudstack](https://cloudstack.apache.org/)  deploy and manage large networks of virtual machines (IaaS) cloud computing platform
* [Foss-Cloud](http://www.foss-cloud.org/en/wiki/FOSS-Cloud) covers all aspects of an virtualized IT environment
* [Open Nebula](http://www.opennebula.org) OpenNebula is made for users by users
* [Open Stack](http://www.openstack.org) OpenStack is made for vendors by vendors
* [Ganeti](http://code.google.com/p/ganeti/)  virtual server management software on top of existing virtualization technologies such as Xen or KVM
* [Convirt](http://convirt.net) is a centralized management solution that lets you manage the complete lifecycle of your KVM deployments.
* [Sheepdog project](http://www.osrg.net/sheepdog) Distributed Storage Management for qemu/kvm

** Configuratiebeheertools**

* [www.opscode.com/chef/](http://www.opscode.com/chef/)
* [www.cfengine.org/](http://www.cfengine.org/)
* [www.puppetlabs.com/puppet/introduction/](http://www.puppetlabs.com/puppet/introduction/)
