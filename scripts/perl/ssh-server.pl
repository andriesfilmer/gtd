#!/usr/bin/perl

# This script extracts two passwords from a encrypted GnuPG (gpg) file.
# So you have to remember just the gpg password to login to all servers.
#
# The servers are configured so that you first login as user and then su to root.
#
# So this script extract two passwords from a single line.
# The format must be: 'host.domain.nl userpasswd rootpasswd'
#
# Install gpg (to remember te passphrase for your session)
# 'sudo apt-get install gpg'
#
# Install libexpect-perl before using this script.
# 'sudo apt-get install libexpect-perl'
#
# Vars
#######
#
$username = $ENV{USER};
$encryptedPassFile = '~/.gnupg/servers.gpg';

# Only for use with 'Get password for gpg-agent from remote ssh-server' option.
$sshCommandForRemotePasswd = 'ssh server05.filmer.net "cat .ssh/gpgpass-file"';

# Perl modules
##############
#
use Expect;
use IO::Pty;

############################################################################

if( ! defined $ARGV[0] ) {
	print "Which Server to login?\n";
	$server_str = <>;
}
else
{
	$server_str = $ARGV[0];
}
chomp($server_str);

my $spawn = new Expect;
#$spawn->debug(1);
$spawn->raw_pty(1);

# This gets the size of your terminal window
$spawn->slave->clone_winsize_from(\*STDIN);

# This function traps WINCH signals and passes them on
sub winch {
	my $signame = shift;
	my $pid = $spawn->pid;
	$shucks++;
	print "count $shucks,pid $pid, SIG$signame\n";
	$spawn->slave->clone_winsize_from(\*STDIN);
	kill WINCH => $spawn->pid if $spawn->pid;
}
$SIG{WINCH} = \&winch;  # best strategy

# Get password from gpg-agent with passphrase prompt.
#--------------------------------------------------
#$gpg_line = `/usr/bin/gpg --decrypt $encryptedPassFile | grep -i '^$server_str'`;
#
# Get password for gpg-agent from remote ssh-server.
#---------------------------------------------------
$gpg_line = `$sshCommandForRemotePasswd | gpg --batch --yes --passphrase-fd 0 -u $username --pinentry-mode loopback -d $encryptedPassFile | grep -i '^$server_str'`;

$gpg_line =~ /^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s*$/;
$host = $1;
$user_pass = $2;
$root_pass =  $3;

# Set the window title
print "\033]0;$host\007";

$spawn=Expect->spawn("ssh $username\@$host");

# log everything if you want
# $spawn->log_file("/tmp/autossh.log.$$");

#my $PROMPT  = '[\]\$\>\#]\s$';

#my $PROMPT = "[\$|\%]";

my $ret = $spawn->expect(1,
  [ qr/\(yes\/no\)\?\s*$/ => sub { $spawn->send("yes\n"); exp_continue; } ],
  [ qr/assword:\s*$/      => sub { $spawn->send("$user_pass\n"); exp_continue; } ]
);

sleep(1);

$spawn->send("su -\n");
my $ret = $spawn->expect(10,
  [ qr/assword:\s*$/ 	=> sub { $spawn->send("$root_pass\n") if defined $root_pass;  } ]
);

# Hand over control
$spawn->interact();
exit;

