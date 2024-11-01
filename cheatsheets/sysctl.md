## Sysctl

View sysctl variables

    sysctl -a
    sysctl -a | grep redirects

Set variables

    sysctl -w net.ipv4.conf.all.send_redirects = 0

Reload config without reboot

    sysctl --system

### Below is a excerpt from resources:
* https://gist.github.com/ThisIsMissEm/83ffaafbdcd0e1280c8b
* https://jivoi.github.io/2015/07/22/ubuntu-security-hardening/

### Digital ocean recommende settings memory
```
net.core.wmem_max=12582912
net.core.rmem_max=12582912
net.ipv4.tcp_rmem= 10240 87380 12582912
net.ipv4.tcp_wmem= 10240 87380 12582912
````

### If swap is enabled, do less swapping
````
vm.swappiness = 10
vm.dirty_ratio = 60
vm.dirty_background_ratio = 2
````

### GENERAL NETWORK SECURITY OPTIONS ###

### Ignore ICMP broadcast requests
````
net.ipv4.icmp_echo_ignore_broadcasts = 1

````
### Ignore ICMP redirects
````
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
````

### Ignore Directed pings
````
net.ipv4.icmp_echo_ignore_all = 1
````

### Ignore send redirects
````
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
````

### Block SYN attacks
````
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5
````

### Protect Against TCP Time-Wait
````
net.ipv4.tcp_rfc1337 = 1
````

### Decrease the time default value for tcp_fin_timeout connection
````
net.ipv4.tcp_fin_timeout = 15
````

### Decrease the time default value for connections to keep alive
````
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15
````

### TUNING NETWORK PERFORMANCE ###

### Default Socket Receive Buffer
````
net.core.rmem_default = 31457280
````

### Maximum Socket Receive Buffer
````
net.core.rmem_max = 12582912
````

### Default Socket Send Buffer
````
net.core.wmem_default = 31457280
````

### Maximum Socket Send Buffer
````
net.core.wmem_max = 12582912
````

### Increase number of incoming connections backlog
````
net.core.netdev_max_backlog = 65536
````

### Increase the maximum amount of option memory buffers
````
net.core.optmem_max = 25165824
````

### Increase the maximum total buffer-space allocatable
### This is measured in units of pages (4096 bytes)
````
net.ipv4.tcp_mem = 65536 131072 262144
net.ipv4.udp_mem = 65536 131072 262144
````

### Increase the read-buffer space allocatable
````
net.ipv4.udp_rmem_min = 16384
````

### Increase the tcp-time-wait buckets pool size to prevent simple DOS attacks
````
net.ipv4.tcp_max_tw_buckets = 1440000
net.ipv4.tcp_tw_reuse = 1
````
