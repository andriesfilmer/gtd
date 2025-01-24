#!/usr/bin/perl

# The servers are configured with PermitRootLogin = NO.
# So that you first login as regular user and then su to root.
###############################################################################
#
# Install libexpect-perl before using this script.
# sudo apt install libexpect-perl
#
# Place this bash function in ~/.bashrc and source ~/.bashrc
# It extracts 'servername, username and password from a rails app called pim.
#
# function autossh() {
#   cd ~/path/to/pim && ~/path/to/autossh.pl `rails ssh:login["$1"]`
# }
#
# Change the `pim` to the pim rails app.
# Change the path `autossh.pl` to this script.
#
# usage in bash terminal: autossh servername
#
################################################################################

# Perl modules
use Expect;
use IO::Pty;

$username = $ENV{USER};

# Check if we have all three arguments
if (@ARGV < 3) {
    print "Not enough arguments. Please enter the missing arguments:\n";

    my @prompts = ("Servername", "Userpassword", "Rootpassword");
    while (@ARGV < 3) {
        print $prompts[@ARGV], ": ";
        chomp(my $arg = <STDIN>);
        push @ARGV, $arg;
    }
}

# Now we have all three arguments
my ($servername, $userpass, $rootpass) = @ARGV;

print "Servername $servername\n";

my $spawn = new Expect;
#$spawn->debug(1);
$spawn->raw_pty(1);

# Set the window title
print "\033]0;$servernam\007";

$spawn=Expect->spawn("ssh $username\@$servername");
sleep(1);
$spawn->slave->clone_winsize_from(\*STDIN);
$SIG{WINCH} = \&winch;

# log everything if you want
# $spawn->log_file("/tmp/autossh.log.$$");

my $ret = $spawn->expect(1,
  [ qr/\(yes\/no\)\?\s*$/ => sub { $spawn->send("yes\n"); exp_continue; } ],
  [ qr/assword:\s*$/      => sub { $spawn->send("$userpass\n"); exp_continue; } ]
);

sleep(1);

$spawn->send("su -\n");
my $ret = $spawn->expect(10,
  [ qr/assword:\s*$/ 	=> sub { $spawn->send("$rootpass\n") if defined $rootpass;  } ]
);

# This gets the size of your terminal window, WINCH ("window size changed")
sub winch {
  $spawn->slave->clone_winsize_from(\*STDIN);
  kill WINCH => $spawn->pid if $spawn->pid;
  $SIG{WINCH} = \&winch;
}

# Hand over control
$spawn->interact();
exit;

