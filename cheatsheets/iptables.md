# iptables

In order to make your iptables rules persistent after reboot

    apt install iptables-persistent

See running firewall (list, numeric, verbose)

    iptables -L -n -v


## Set a Safety Net

Ensure that you don't lock yourself out on a remote server reset iptables rules in case something goes wrong.
Before flushing all the chains, ensure all chains have a policy of ACCEPT!

    iptables -P INPUT ACCEPT
    echo "iptables -F" | at now + 10 minutes

### Blocking termporarly

    iptables -A INPUT -s 203.0.113.51 -j DROP
    iptables -A INPUT -i eth0 -s 203.0.113.51 -j DROP

To unblock (take the exact rule and replace -A with -D.

    iptables -D INPUT -s 203.0.113.51 -j DROP
    iptables -D INPUT -i eth0 -s 203.0.113.51 -j DROP

## Saving rules

To update persistent iptables with new rules simply use iptables command to include new rules into your system.
To make changes permanent after reboot run iptables-save command:

    iptables-save > /etc/iptables/rules.v4
    ip6tables-save > /etc/iptables/rules.v6

## Restoring rules

    iptables-restore < /etc/iptables/rules.v4
    ip666666tables-restore < /etc/iptables/rules.v6

# iptables example

````
*filter
:INPUT DROP [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

# ACCEPT LOOPBACK
-A INPUT -i lo -j ACCEPT
# FIRST PACKET HAS TO BE TCP SYN
-A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# DROP FRAGMENTS
-A INPUT -f -j DROP

# DROP XMAS PACKETS
-A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# DROP NULL PACKETS
-A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# DROP EXCESSIVE TCP RST PACKETS
-A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

# DROP ALL INVALID PACKETS
-A INPUT -m state --state INVALID -j DROP
-A FORWARD -m state --state INVALID -j DROP
-A OUTPUT -m state --state INVALID -j DROP

# DROP RFC1918 PACKETS
-A INPUT -s 10.0.0.0/8 -j DROP
-A INPUT -s 172.16.0.0/12 -j DROP
-A INPUT -s 192.168.0.0/16 -j DROP

# DROP SPOOFED PACKETS
-A INPUT -s 169.254.0.0/16 -j DROP
-A INPUT -s 127.0.0.0/8 -j DROP
-A INPUT -s 224.0.0.0/4 -j DROP
-A INPUT -d 224.0.0.0/4 -j DROP
-A INPUT -s 240.0.0.0/5 -j DROP
-A INPUT -d 240.0.0.0/5 -j DROP
-A INPUT -s 0.0.0.0/8 -j DROP
-A INPUT -d 0.0.0.0/8 -j DROP
-A INPUT -d 239.255.255.0/24 -j DROP
-A INPUT -d 255.255.255.255 -j DROP

# ICMP SMURF ATTACKS + RATE LIMIT THE REST
-A INPUT -p icmp --icmp-type address-mask-request -j DROP
-A INPUT -p icmp --icmp-type timestamp-request -j DROP
-A INPUT -p icmp --icmp-type router-solicitation -j DROP
-A INPUT -p icmp -m limit --limit 2/second -j ACCEPT

# ACCEPT SSH
-A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

# DROP SYN-FLOOD PACKETS
-A INPUT -p tcp -m state --state NEW -m limit --limit 50/second --limit-burst 50 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -j DROP

# ALLOW ESTABLISHED CONNECTIONS
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

###############################################################################
# OTHER CUSTOM RULES
###############################################################################

# No incomming mail on this server.
-A INPUT -p tcp --destination-port 25 -j DROP

COMMIT
````
Source: <https://networklessons.com/uncategorized/iptables-example-configuration>


## Explanation of Rules

### Accept Loopback Traffic

    -A INPUT -i lo -j ACCEPT

We should permit local traffic on the server.

### First TCP segment requires SYN bit

    -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

When TCP establishes a connection, it will perform a 3-way handshake. The first TCP packet always has the SYN bit set. If it doesn’t have this, we will drop the traffic.

### No Fragments allowed
    -A INPUT -f -j DROP

We don’t allow fragmented IP Packets.

### XMAS Packets
    -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

A TCP packet that has all the flags set is called an XMAS packet and should never be accepted.

### Null Packets

    -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

A Null packet is a TCP packet without any flags. This is never used in legitimate traffic, so it should be dropped.

### Excessive TCP RST Packets

    -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

The TCP RST (Reset) is used to abort a TCP connection, so we shouldn’t see many of these at the same time. They are accepted but limited to 2 per second with a burst of 2.

### Invalid Packets

    -A INPUT -m state --state INVALID -j DROP
    -A FORWARD -m state --state INVALID -j DROP
    -A OUTPUT -m state --state INVALID -j DROP

When using stateful packet inspection, a packet can be new, established, or related. When it’s not one of these, it is considered invalid and should be dropped.

### RFC 1918 Packets

    -A INPUT -s 10.0.0.0/8 -j DROP
    -A INPUT -s 172.16.0.0/12 -j DROP
    -A INPUT -s 192.168.0.0/16 -j DROP

On the Internet, we should never see IP packets from private IP addresses, so we’ll drop them.

### Spoofed Packets

    -A INPUT -s 169.254.0.0/16 -j DROP
    -A INPUT -s 127.0.0.0/8 -j DROP
    -A INPUT -s 224.0.0.0/4 -j DROP
    -A INPUT -d 224.0.0.0/4 -j DROP
    -A INPUT -s 240.0.0.0/5 -j DROP
    -A INPUT -d 240.0.0.0/5 -j DROP
    -A INPUT -s 0.0.0.0/8 -j DROP
    -A INPUT -d 0.0.0.0/8 -j DROP
    -A INPUT -d 239.255.255.0/24 -j DROP
    -A INPUT -d 255.255.255.255 -j DROP

We shouldn’t see the ranges above, so when we do, they are considered as spoofed and dropped.

### ICMP Smurf Attack and Rate Limit

    -A INPUT -p icmp --icmp-type address-mask-request -j DROP
    -A INPUT -p icmp --icmp-type timestamp-request -j DROP
    -A INPUT -p icmp --icmp-type router-solicitation -j DROP
    -A INPUT -p icmp -m limit --limit 2/second -j ACCEPT

We allow most ICMP traffic, but it is rate-limited.

### SSH Connections

-A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT
SSH is allowed for remote access.

### SYN Flood Protection

    -A INPUT -p tcp -m state --state NEW -m limit --limit 50/second --limit-burst 50 -j ACCEPT
    -A INPUT -p tcp -m state --state NEW -j DROP

An SYN flood is a DOS attack where the attacker sends a lot of SYN packets but never completes the 3-way handshake. As a result, the server will have a lot of “half-open” connections and might not be able to serve new connections. Be careful with this setting, as this is a global limit.

### Established Connections

    -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

Packets with the “new” state are checked with our first rule. We drop “invalid” packets so that at the end, we can accept all “related” and “established” packets.


## Web Server Protection

Let’s assume we want to rate limit incoming requests to our web server to prevent Denial-of-Service (DoS) attacks and ensure fair resource allocation among users. We can achieve this using the iptables conntrack extension:

    iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW -m limit --limit 20/min --limit-burst 30 -j ACCEPT
    iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW -m limit --limit 20/min --limit-burst 30 -j ACCEPT
    iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW -j DROP
    iptables -A INPUT -p tcp --dport 443 -m conntrack --ctstate NEW -j DROP

First, we configure iptables to accept already established connections. Then, we define two rules that accept new connections
to ports 80 and 443 while tracking the number of connections from each unique IP address. These rules continue to accept
new connections as long as they don’t exceed the limit of 20 connections per minute from each IP address.

