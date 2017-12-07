#!/usr/bin/perl

use LWP;
use HTTP::Request::Common;

if ($#ARGV < 0) { die "perl webserver_check.pl [server]\n" }

$server = $ARGV[0];

my $response = LWP::UserAgent->new->
simple_request(HEAD "http://".$server);

unless ($response->is_error) {

 print "server: ", $response->server, "\n";

} else {

 print "webserver: $server is down!\n";

 $toaddress="beheer\@filmer.nl\n";

 open (MAIL,"| /usr/sbin/sendmail -t") || print "Can't open mailer path\n";
 print MAIL "From: www\@host.filmer.nl\n";
 print MAIL "To: $toaddress";
 print MAIL "Subject: Error $server\n\n";
 print MAIL "Webserver $server is down....";
 close MAIL;

}

