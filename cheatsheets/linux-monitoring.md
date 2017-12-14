# Commandline system monitoring

## Introduction

There are many commandline monitoring tools. On this page you can find a list of commands who I commonly use. The first part are commands you can use without installing a package. This page gives only some shorthand examples. The man pages can tell you much more ;)

## Part 1 (default system tools)

### ps

Print process on the server

    ps aux
    ps auxww                                      # Wrapping commands
    ps -ejH                                          # Print A Process Tree
    ps axjf
    pstree
    pgrep apache                               # Display Only The Process IDs of apache
    ps -auxf | sort -nr -k 4 | head -10 # Find Out The Top 10 Memory Consuming Process

### free

    free -o  # Displays Memory Usage

### top

By default, it displays the most CPU-intensive tasks running on the server and updates the list every five seconds.

    top

### vmstat

System Activity, Hardware and System Information

    vmstat 3            # About processes, memory, paging, block IO, traps, and cpu activity
    vmstat -a           # About Active / Inactive Memory Pages
    sudo vmstat -m # Display Memory Utilization Slabinfo

### uptime

Tell How Long The System Has Been Running

    uptime

### watch

Watch changeable data continuously

    watch free                                    # reruns the 'free' a command every 2 seconds by default.
    watch -n.1 'cat /proc/interrupts'# To see the interrupts occurring on your sys  tem.


## Part II (installed system tools)

### dstat

Versatile tool for generating system resource statistics

    apt-get install dstat

[dag.wieers.com/home-made/dstat/](http://dag.wieers.com/home-made/dstat/)

### ngrep

Ngrep is a pcap-aware tool that will allow you to specify extended regular expressions to match against data part of packets on the network.

No arguments. Shows all traffic going through the default network card.
    ngrep -qd eth1 'HTTP' tcp port 80

Be quiet, look only at tcp packets with either source or dest port 80 on interface eth1, look for anything matching 'HTTP'.
    ngrep -qd le0 port 53

Watch all tcp and udp port 53 (nameserver) traffic on interface le0. Be quiet.
    ngrep 'USER|PASS' tcp port 21

Look only at tcp packets with either source or dest port 21, look for anything resembling an FTP login.
    ngrep -wiA 2 'user|pass' tcp port 21

### atop

AT Computing's System & Process Monitor

    apt-get install atop

The program atop is an interactive monitor to view the load on a Linux system. It shows the occupation of the most critical hardware resources (from a performance point of view) on system level, i.e. cpu, memory, disk and network.

When running atop interactively (no output redirection), keys can be pressed to control the output. In general, lower case keys can be used to show other information for the active processes and upper case keys can be used to influence the sort order of the active process list.

g # Show generic output (default).
m # Show memory related output.
d # Show disk-related output.
n # Show network related output ''(when kernel patch 'cnt' is installed)''.
s # Show scheduling characteristics.
v # Show various process characteristics.
c # Show the command line of the process.
u # Show the process activity accumulated per user.
p # Show the process activity accumulated per program (i.e. process name).

Useful website: [no link tekst](http://www.atoptool.nl) for patch and more info. The man page is very useful too ;)

### nethogs

Net top tool grouping bandwidth per process

Instead of breaking the traffic down per protocol or per subnet, like most tools do, it groups bandwidth by process. If there's suddenly a lot of network traffic, you can fire up NetHogs and immediately see which PID is causing this.

    apt-get install nethogs

More info: [no link tekst](http://nethogs.sourceforge.net)

###  iostat

Average CPU Load, Disk Activity

    apt-get install iostat

    iostat

### bmon

Graphs/tracks network activity/bandwidth real time.

    apt-get install bmon

Just type bmon to see your network activity/bandwith in real time ;)

    bmon

### inotify, incron and authctl

There is a separate page about [Monitoring file system events with inotify, incron and authctl](kb/129).
Very usefull if you want to know what files are created or modified.

### Stress

Check the system onder (heavy) load.

    apt-get install stress

    stress -c 20 -i 4 --verbose --timeout 1h

## Others

I don't use the next tools, but maybe you like them.

* sar - Collect and Report System Activity
* multitail – tail multiple files in a single terminal window
* swatch – [track your log files and fire off alerts](http://www.linuxjournal.com/article/4776?page=0,2)
* iftop - display bandwidth usage on an interface by host

## Resources

* [www.cyberciti.biz/tips/top-linux-monitoring-tools.html](http://www.cyberciti.biz/tips/top-linux-monitoring-tools.html)
* [www.cyberciti.biz/tips/top-linux-monitoring-tools.html](www.cyberciti.biz/tips/top-linux-monitoring-tools.html)
* [www.bebits.com/app/3270](http://www.bebits.com/app/3270) ngrep
