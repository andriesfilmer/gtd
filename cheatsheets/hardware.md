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

## Show resolution information
    xrandr

## Show Linux System Information

Use uname command to show Linux system information
    uname -a
