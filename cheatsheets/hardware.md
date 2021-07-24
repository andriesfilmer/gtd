## Hardware information

Most easy way is to install GUI hardinfo

   sudo apt install hardinfo

Or

    lshw
    lsusb
    sudo dmidecode

To get information about '''Base Board,Processor,Memory Module,Cache,Memory Device,Memory Device'''.

    sudo dmidecode 2,4,6,7,17

Processor information

    cat /proc/cpuinfo
    lscpu

VGA Card

    lspci | grep VGA

Check graphix driver

    glxinfo | grep "OpenGL"


List block devices

    lsblk

## Distribution information

    cat /etc/*release

or more nice with '''LSB (Linux Standard Base)'''

    lsb_release -a

## Simulating hardware reset button in Linux

There are some cases in which you couldn’t reboot a Linux system with reboot command or alternatives.
If you have this problem and you don’t have physical access to server, it is also possible to simulate pressing hardware reset button with the help of sysrq support in kernel.

To reboot the system through this magic interface, you need to activate sysrq first because it is disabled by default on all modern Linux distributions:

    # echo 1 > /proc/sys/kernel/sysrq

After that you can send b trigger to reboot system immediately like that:

    # echo b > /proc/sysrq-trigger

Please note that, rebooting with this method results to some data being lost. So, this method must be used only if there are no other chance to reboot system.

## Show resolution information

    xrandr

With the above output (on te secondline) you can find the diplay name i.o. `DP-0`.

    xrandr --output DP-0 --brightness 0.65

Set night mode

  xrandr --output DP-0 --gamma 0.8:0.6:0.4 --brightness 0.55

Set (normal) day mode

    xrandr --output DP-0 --gamma 1:1:1 --brightness 1


## Show Linux System Information

Use uname command to show Linux system information

    lsb_release -a
    uname -a
