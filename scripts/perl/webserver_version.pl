#!/usr/bin/perl

use LWP;
use HTTP::Request::Common;

if ($#ARGV < 0) { die "perl webserver_version.pl [server]\n" }

$server = $ARGV[0];

my $response = LWP::UserAgent->new->
simple_request(HEAD "http://".$server);

unless ($response->is_error) {
 print "server: ", $response->server, "\n";

} else {

 print "error: ", $response->status_line, "\n";

}

