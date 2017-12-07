#!/usr/bin/perl

# rename all files from spaces to underscores

use File::Find;

find(\&underscores, ".");

sub underscores {
	next if -d $_;
	next if /^\./;

	my $file = $_;
	$file    =~ s/ /_/g;

	#rename($_, $file) or die $!;
	print "$_, $file\n";

}

