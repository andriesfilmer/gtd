# Linux networking tools

Some notes for networking on GNU / linux

## ip

ip has shortcuts: `ip address show` is the same as `ip a s`. Check `ip help` (`ip`).

    ip a s             # address show
    ip -c a s          # with colors for ipnrs
    ip -4 a s dev eth0 # only ipv4 on eth0
    ip -br -4 a s      # Show -brief output
    ip -0 a s dev eth0 # only mac-address on eth0

    ip r s             # show route

    ip neighbor show   # Arp
    ip -stats -human link show

## DNS

    resolvectl status

### Alternative DNS servers

vi `/etc/netplan/01-network-manager-all.yaml`

    network:
      version: 2
      renderer: networkd
      ethernets:
        # Find your DEVICE_NAME with `ip a`
        # DEVICE_NAME i.o. enp2s0 or enp4s0
        enp2s0:
          dhcp4: yes
          dhcp4-overrides:
            use-dns: no
          nameservers:
            #addresses: [8.8.4.4,8.8.8.8]
            addresses: [208.67.222.222,208.67.220.220]

    netplan apply

#### Ubuntu <= 18.04

Edit `/etc/resolvconf/resolv.conf.d/head`

    # Google DNS servers Preferred/Alternate:
    nameserver 8.8.8.8
    nameserver 8.8.4.4

    # OpenDNS (preferred/alternate)
    nameserver 208.67.222.222
    nameserver 208.67.220.220

    # Local DNS with dnsmasq
    nameserver 127.0.0.1

Tell resolvconf to regenerate a new resolv.conf.

    resolvconf --enable-updates
    resolvconf -u

    systemctl restart networking

### Clear DNS cache in chrome/chromium

    chrome://net-internals/#dns


### Enable wildcard subdomain with dnsmasq

    apt-get install dnsmasq

Open `/etc/dnsmasq.conf` and add:

    address=/lvh.me/127.0.0.1


    systemctl stop systemd-resolved
    #systemd-resolve --flush-caches
    #systemctl restart resolvconf.service
    #systemctl disable systemd-resolved


### Which DNS am I using

    systemd-resolve --status

Use custom nameservers add a line to `/etc/dhcp/dhclient.conf`:

    # Open DNS
    supersede domain-name-servers 208.67.222.222, 208.67.220.220;
    # Google
    supersede domain-name-servers 8.8.8.8, 8.8.4.4;


## AdGuard

AdGuard Home is a network-wide software for blocking ads & tracking.
After you set it up, it'll cover ALL your home devices,
and you don't need any client-side software for that.

<https://github.com/AdguardTeam/AdGuardHome#getting-started>

## ss – Network Statistics

ss command use to dump socket statistics. It allows showing information similar to `netstat`.

    ss -tulp # All TCP and UDP listen sockets

## Devices

If you want to see the names of all the network devices on the system

    ls /sys/class/net

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
