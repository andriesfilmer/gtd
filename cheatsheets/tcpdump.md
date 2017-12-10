## Tcpdump

Don't  convert  addresses

    tcpdump -ni eth0 'port 22'

To print all packets arriving at or departing from sundown:

    tcpdump host hostname.filmer.nl

Print all tcp traffic not from filmer.xs4all.nl and stockholm

    tcpdump not host (filmer.xs4all.nl or stockholm)

To print traffic between helios and either hot or ace:

    tcpdump host helios and ( hot or ace )

To print all IP packets between ace and any host except helios:

    tcpdump ip host ace and not helios

To print all traffic between local hosts and hosts at Berkeley:

    tcpdump net ucb-ether

To print all ftp traffic through internet gateway snup: (note that the expression is quoted to prevent the shell from (mis-)interpreting the parentheses).

    tcpdump 'gateway snup and (port ftp or ftp-data)'

To print traffic neither sourced from nor destined for local hosts (if you gateway  to one other net, this stuff should never make it onto your local net).

    tcpdump ip and not net localnet

To print the start and end packets (the SYN and FIN packets) of each TCP conversation that involves a non-local host.

    tcpdump 'tcp[13] & 3 != 0 and not src and dst net localnet'

To print IP packets longer than 576 bytes sent through gateway snup:

    tcpdump 'gateway snup and ip[2:2] > 576'

To print IP broadcast or multicast packets that were not sent via ethernet broadcast or multicast:

    tcpdump 'ether[0] & 1 = 0 and ip[16] >= 224'

To print all ICMP packets that are not echo requests/replies (i.e., not ping packets):

    tcpdump 'icmp[0] != 8 and icmp[0] != 0'

