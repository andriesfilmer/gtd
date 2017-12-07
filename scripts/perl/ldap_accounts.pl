#!/usr/bin/perl

# This script fills the LDAP subtree ou=account,dc=filmer.nl,dc=nl with accounts defined in
# MySQL (table ldap_account).
# The script runs on the LDAP server ldap.filmer.nl, but it is possible to move the script to
# another server, as long as it can connect to ldap.filmer.nl and it has the package ldap-utils
# installed.
#
# Required packages: libcrypt-smbhash-perl libclass-dbi-mysql-perl libdigest-sha1-perl

use strict;

use Getopt::Long;
use DBI;
use Crypt::SmbHash qw(lmhash nthash);
use Digest::SHA1;
use MIME::Base64;

my $result = GetOptions ("help" => \my $help, "service=s" => \my $service, "user=s" => \my $user, "full" => \my $full);

if ($help)
{
	print "Usage: create_ldap_accounts.pl [-hf] [ -s service ] [ -u user ]
	-h, --help display this help text
	-s, --service service
		'service' is an authorizedServiced like 'ftp'. Only accounts having this
		service will be updated. By default all services are updated.
	-u, --user user
		'user' is the user to update. By default all users are updated.
	-f, --full
		By default only changed accounts will be updated, use this option to update
		all accounts.\n";
	exit;
}

my $update_ldap_where = ' AND update_ldap ';
my $service_where = '';
my $user_where = '';

if ($full)
{
	$update_ldap_where = '';
}

if ($service)
{
	$service_where = " AND FIND_IN_SET('$service', authorizedServices) ";
}
if ($user)
{
        $user_where = " AND uid LIKE \"$user\" ";
}


my $dbh = mysql_connect('mysqladmin.filmer.nl', 'filmer', 'filmeradmin');

my $sth = $dbh->prepare("SELECT uid, uidNumber, gidNumber, cn, userPassword, homeDirectory, authorizedServices, hosts
                    FROM ldap_account
                    WHERE enabled $service_where $user_where $update_ldap_where
                    ");
$sth->execute;

# set update_ldap=0 for all accounts that we are going to update
my $sth2 = $dbh->prepare("UPDATE ldap_account SET update_ldap = '0'
                WHERE enabled $service_where $user_where $update_ldap_where
		");
$sth2->execute;


my $uid;
my $uidNumber;
my $gidNumber;
my $cn;
my $userPassword;
my $homeDirectory;
my $authorizedServices;
my $hosts;

while ( ($uid, $uidNumber, $gidNumber, $cn, $userPassword, $homeDirectory, $authorizedServices, $hosts) = $sth->fetchrow_array )
{
	my ($hashedPasswd,$salt);
	$salt = &get_salt8;
	my $ctx = Digest::SHA1->new;
	$ctx->add($userPassword);
	$ctx->add($salt);
	$hashedPasswd = '{SSHA}' . encode_base64($ctx->digest . $salt ,'');


	my $ldif = "
	dn: uid=$uid,ou=account,dc=filmer,dc=nl
	objectClass: account
	objectClass: posixAccount
	objectClass: shadowAccount
	objectClass: authorizedServiceObject
	uid: $uid
	cn: $cn
	userPassword: $hashedPasswd
	loginShell: /bin/bash
	uidNumber: $uidNumber
	gidNumber: $gidNumber
	homeDirectory: $homeDirectory
	";
	my @authorizedServices =  split(/,/, $authorizedServices);
	my @hosts =  split(/,/, $hosts);

	foreach (@authorizedServices)
	{
		$ldif .= "authorizedService: $_\n";
		if ($_ eq 'samba')
		{
			my $sambaLMPassword = lmhash($userPassword);
			my $sambaNTPassword = nthash($userPassword);
			my $sambaUidNumber = $uidNumber * 2 + 1000;
			$ldif .= "
			objectClass: sambaSamAccount
			sambaSID: S-1-5-21-1244431012-3564389383-2055980186-$sambaUidNumber
			sambaLMPassword: $sambaLMPassword
			sambaNTPassword: $sambaNTPassword
			sambaAcctFlags: [UX]
			";
		}
	}

	foreach (@hosts)
	{
		$ldif .= "host: $_\n";
	}

	# remove tabs
	$ldif =~ s/\t//g;

	# remove multiple newlines
	$ldif =~ s/\n{2,}/\n/g;

	`ldapdelete -x -D "uid=accountadmin,ou=account,dc=filmer,dc=nl" -w password "uid=$uid,ou=account,dc=filmer,dc=nl" -Z`;
	open(LDAPADD,'|ldapadd -x -D "uid=accountadmin,ou=account,dc=filmer,dc=nl" -w password -c -Z');
	print LDAPADD $ldif;
	close LDAPADD;
}

# Get (new) disabled accounts
my $sth = $dbh->prepare("SELECT uid
	FROM ldap_account
	WHERE !enabled $service_where $user_where $update_ldap_where
");
$sth->execute;

# set update_ldap=0 for all accounts that we are going to delete
my $sth2 = $dbh->prepare("UPDATE ldap_account SET update_ldap = '0'
                WHERE !enabled $service_where $user_where $update_ldap_where
                ");
$sth2->execute;

# Remove disabled accounts
while ( ($uid) = $sth->fetchrow_array )
{
	print "Deleting account $uid\n";
	`ldapdelete -x -D "uid=accountadmin,ou=account,dc=filmer,dc=nl" -w password "uid=$uid,ou=account,dc=filmer,dc=nl" -Z`;
}

sub get_salt8 {
        my $salt = join '', ('a'..'z')[rand 26,rand 26,rand 26,rand 26,rand 26,rand 26,rand 26,rand 26];
        return($salt);
}



sub mysql_connect()
{
     use Cwd qw(realpath);
     # Get path including filename
     my $path = realpath($0);
     # Remove filename
     $path =~ s/[^\/]*$//;

     my $password_file = $_[0] . '-' . $_[1] . '-' . $_[2];
     open(FILE, $path . $password_file) or die("Unable to open file $password_file");
     my @data = <FILE>;
     close(FILE);
     # The password must be on the first line
     my $password = $data[0];
     chomp($password);
     my $dbh = DBI->connect('DBI:mysql:database=' . $_[1] . ';host=' . $_[0] , $_[2], $password) || die "Unable to connect to db";
     $dbh->{ mysql_auto_reconnect } = 1;
     return $dbh;
}


__END__


