# Linux networking tools

Some notes for networking on GNU / linux

## Create a simple interface 

    ifconfig eth0 192.168.1.99 netmask 255.255.255.0 broadcast 192.168.1.255
    route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.1.1 eth0

## netstat

List internet services on a system

    netstat -tupl

List active connections to/from system

    netstat -tup

## lsof

So to see which process is listening upon port 3000 we can run:

    lsof -i | grep 3000

## avahi

Then use `avahi-browse -a`  or more verbose:

    avahi-browse -atr

## Network tools

    apt-get install ethtool net-tools

Output eth0 configuration options

    ethtool eth0

Same with MII View (or manipulate media-independent interface) status

    mii-tool eth0

Change the speed and duplex settings

Disable autonegotiation, and force the MII to either 100baseTx-FD, 100baseTx-HD, 10baseT-FD, or 10baseT-HD

    mii-tool -F 100baseTx-HD
    mii-tool -F 10baseT-HDSetup

Negotiated speed with ethtool

    ethtool -s eth0 speed 100 duplex full
    ethtool -s eth0 speed 10 duplex half


Redirect ip-address port to other server port

    /usr/local/bin/redir --laddr 82.201.122.21 --lport 80 --caddr 194.242.19.13 --cport 80

## nmap

Scan for Active Hosts on a network (no port scan)

    nmap -sn 192.168.1.0/24

Scan for port range on ip

    nmap -p 0-1000 192.168.1.1

Scan for All TCP Ports

    nmap -sT 192.168.1.1

Scan for Particular TCP Ports:

    nmap -p T:80 192.168.1.1

Scan for All UDP Ports

    nmap -sU 192.168.1.1

Scan for Particular UDP Ports

    nmap -p U:53 192.168.1.1

Combine scanning of different ports

    nmap -p U:53,79,113,T:21-25,80,443,8080 192.168.1.1

Enable Fast Mode (Scan fewer ports than the default scan)

    nmap -F 192.168.1.1

Show Only Open Ports (or possibly open)

    nmap --open 192.168.1.1

Prints out the OS details if there is a match.

    nmap -O 192.168.1.1

Service Version Detection

    nmap -sV 192.168.1.1

Find out if a host is protected by any Packet Filters or Firewall:

    nmap -sA 192.168.1.1

Spoof your MAC Address

    nmap --spoof-mac 00:11:22:33:44:55 192.168.1.1

Spoof your MAC Address with a Random MAC 

    nmap --spoof-mac 0 192.168.1.1

[Anonymous Port Scanning: Nmap + Tor + ProxyChains](https://www.shellhacks.com/anonymous-port-scanning-nmap-tor-proxychains/)