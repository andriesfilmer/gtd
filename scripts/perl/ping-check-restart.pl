#!/usr/bin/perl -w

use Net::Ping;

#$host = "www.filmer.nl"; 
#$p = Net::Ping->new();
#print "$host is alive.\n" if $p->ping($host);
#$p->close();

@host_array = ("server.filmer.nl");
$p = Net::Ping->new("icmp");
foreach $host (@host_array)
{
	exec('/etc/init.d/networking restart') unless $p->ping($host, 2);
	sleep(3);

	unless($p->ping($host, 2))
	{
		print "vm02 has no network!\n";
		$toaddress="andries\@filmer.nl\n";
		open (MAIL,"| /usr/sbin/sendmail -t") || print "Can't open mailer path\n";
		print MAIL "From: www\@vm02.filmer.nl\n";
		print MAIL "To: $toaddress";
		print MAIL "Subject: Network error\n\n";
		print MAIL "Network vm02 is down....";
		close MAIL;
	}
}
$p->close();

#$p = Net::Ping->new("tcp", 2);
#while ($stop_time > time())
#{
#    print "$host not reachable ", scalar(localtime()), "\n"
#        unless $p->ping($host);
#    sleep(300);
#}
#undef($p);
#
## For backward compatibility
#     print "$host is alive.\n" if pingecho($host);
