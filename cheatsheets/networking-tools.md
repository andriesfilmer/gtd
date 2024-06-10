# Linux networking tools

## netplan

Returns brief and readable output

    netstat -plunt

## iftop

    sudo apt install iftop

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

