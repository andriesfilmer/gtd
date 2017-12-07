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
$dbpass = "xxxxxxxx";
$db     = "database";
$dbi    = "DBI:mysql:database=$db;host=$dbhost";

###############################################################################

use DBI;

# Connect to database
#
$dbh=DBI->connect($dbi,$dbuser,$dbpass) || die "Cannot connect to db server DBI::errstr,\n";

# Create a vhost.conf
#
open OF, "> /tmp/export_naw_bb_tmp.txt";

print OF "\"First Name\",\"Middle Name\",\"Last Name\",\"Title\",\"Company Name\",\"Work Phone\",\"Home Phone\",\"Fax\",\"Mobile Phone\",\"PIN\",\"Pager\",\"Email Address 1\",\"Email Address 2\",\"Email Address 3\",\"Address1\",\"Address2\",\"City\",\"State/Prov\",\"Zip/Postal Code\",\"Country\",\"Notes\",\"Interactive Handheld\",\"1-way Pager\",\"User Defined 1\",\"User Defined 2\",\"User Defined 3\",\"User Defined 4\"\n";


# Fetch data
#
$sth=$dbh->prepare("select voornaam,tussen,achternaam,titel,bedrijf,telefoon,telefoon2,fax,mobile,email,bezoekadres,postadres,bezoekplaats,bezoekpostcode,bezoekland,notities from naw;");

$sth->execute;
while (( $voornaam,$tussen,$achternaam,$titel,$bedrijf,$telefoon,$telefoon2,$fax,$mobile,$email,$bezoekadres,$postadres,$bezoekplaats,$bezoekpostcode,$bezoekland ) = $sth->fetchrow_array ) 
{

     print OF "\"$voornaam\",\"$tussen\",\"$achternaam\",\"$titel\",\"$bedrijf\",\"$telefoon\",\"$telefoon2\",\"$fax\",\"$mobile\",,,\"$email\",,,\"$bezoekadres\",\"$postadres\",\"$bezoekplaats\",,\"$bezoekpostcode\",\"$bezoekland\",,,,,,,\n"

}
$sth->finish;
$dbh->disconnect();

close OF;

