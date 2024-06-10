# Networking


## ip

    ip a               # addresses show
    ip -c -br a        # Verify network interfaces (-br = breath, -c = color addresses)
    ip -4 a dev eth0   # only ipv4 on eth0
    ip -0 a dev eth0   # only mac-address on eth0
    ip r               # show route
    ip neighbor        # Arp

## ifup/ifdown

    ifup eth0
    ifup --force eth0  # If these command fail or the interface may be in an UNKNOWN state

## dns

    ping 8.8.8.8
    ping google.com

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

    netplan try     # timeout to accept the new configuration
    netplan apply   # or direct apply

## Digitalocean

    cloud-init -v
    apt install cloud-init --reinstall

Resource for Digitalocean: <https://docs.digitalocean.com/support/how-do-i-debug-my-droplets-network-configuration/>

## ss – Network Statistics

ss command use to dump socket statistics. It allows showing information similar to `netstat`.

    ss -tulp # All TCP and UDP listen sockets

## lsof

So to see which process is listening upon port 3000 we can run:

    lsof -i | grep 3000
    lsof -i | grep mysql

## avahi

Then use `avahi-browse -a`  or more verbose:

    avahi-browse -atr

## Redirect ip-address

Port to other server port

    /usr/local/bin/redir --laddr 82.201.122.21 --lport 80 --caddr 194.242.19.13 --cport 80

