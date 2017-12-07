#!/usr/bin/perl

use strict;
use warnings;

my $ctime = time;

# assign the returned list elements to scalars for ease of use
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
 
my @weekdays = qw(Zondag Monday Tuesday Wednesday Thursday Friday Zaterdag);
my @months = ( "January", "February", "March", "April",
                   "May", "June", "July", "August", "September",
                   "October", "November", "December" );
#
#print "Date is: $weekdays[$wday], $months[$mon] $mday, ", 1900 + $year, "\n";
#
 
my $days = 160;
my @dates;
 
while (@dates < $days) {
    my ($day, $month, $year, $wday) = (localtime($ctime))[3..6];
    $year += 1900;
    $month++;
 
    if ($wday eq 0 || $wday eq 6)
    {
	push @dates, sprintf('%04d-%02d-%02d ', $year, $month, $day) . $weekdays[$wday];
    }

    $ctime += (60 * 60 * 24);
    
}
 
 
print "$_\n" for @dates;
