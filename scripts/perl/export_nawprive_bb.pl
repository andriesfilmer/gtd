#!/usr/bin/perl
#
###############################################################################
# Description:
# Export naw information to the Blackbarry 7100v into a cvs file.
###############################################################################

# DB Vars
#
$dbuser = "username";
$dbhost = "mysql.filmer.nl";
$dbpass = "xxxxxxx";
$db     = "database";
$dbi    = "DBI:mysql:database=$db;host=$dbhost";

###############################################################################

use DBI;

# Connect to database
#
$dbh=DBI->connect($dbi,$dbuser,$dbpass) || die "Cannot connect to db server DBI::errstr,\n";

# Create a vhost.conf
#
open OF, "> /tmp/export_nawprive_bb_tmp.txt";

print OF "\"First Name\",\"Middle Name\",\"Last Name\",\"Title\",\"Company Name\",\"Work Phone\",\"Work Phone 2\",\"Home Phone\",\"Fax\",\"Mobile Phone\",\"Email Address 1\",\"Address1\",\"City\",\"Zip/Postal Code\"\n";


# Fetch data
#
$sth=$dbh->prepare("select voornaam,tussen,achternaam,titel,bedrijf,telefoon,telefoon2,prive_telefoon,fax,mobile,email,adres,plaats,postcode from nawprive;");

$sth->execute;
while (( $voornaam,$tussen,$achternaam,$titel,$bedrijf,$telefoon,$telefoon2,$prive_telefoon,$fax,$mobile,$email,$adres,$plaats,$postcode ) = $sth->fetchrow_array ) 
{

     print OF "\"$voornaam\",\"$tussen\",\"$achternaam\",\"$titel\",\"$bedrijf\",\"$telefoon\",\"$telefoon2\",\"$telefoon_prive\",\"$fax\",\"$mobile\",\"$email\",\"$adres\",\"$plaats\",\"$postcode\"\n"

}
$sth->finish;
$dbh->disconnect();

close OF;

