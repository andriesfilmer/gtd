#!/usr/bin/perl
#
###############################################################################
# Description:
# Send a mail from pim.filmer.nl -> events.
###############################################################################

# DB Vars
#
$dbuser = "username";
$dbhost = "mariadb.filmer.net";
$dbpass = "xxxxxxx";
$db     = "database";
$dbi    = "DBI:mysql:database=$db;host=$dbhost";

###############################################################################

use DBI;
use Time::Local;
use Time::localtime;
use Date::Calc qw(Delta_DHMS);

$tm = localtime;
($day, $month, $year) = ($tm->mday, $tm->mon, $tm->year);;
$today = sprintf("%04d%02d%02d", $year+1900, $month+1, $day);

# Connect to database
#
$dbh=DBI->connect($dbi,$dbuser,$dbpass) || die "Cannot connect to db server DBI::errstr,\n";


open OF, "> /tmp/export_cal_bb_tmp.txt";

# Fetch data
#
$sth=$dbh->prepare("	SELECT DISTINCT cal_date,cal_time,cal_duration,cal_name
			FROM webcal_entry 
			INNER JOIN webcal_entry_user 
			ON (webcal_entry_user.cal_id = webcal_entry.cal_id)
			WHERE cal_login = 'andries' AND cal_date >= '$today' limit 20");

$sth->execute;
while (( $cal_date,$cal_time,$cal_duration,$cal_name) = $sth->fetchrow_array ) 
{
    # if cal_time is -1 it is a all day event.
    if ($cal_time eq -1) 
    {
        $set_alarm = 0 ;
    }
    else 
    {
        $set_alarm = 1 ;
    }
    $cal_time =~ s/-1/234500/g;

    # Make cal_time xxxx instead off xxxxxx
    if (length($cal_time) < 6)
    {
        $cal_time = "0${cal_time}";
    }
    $cal_time = substr($cal_time,0,4);

    system("/usr/bin/ssh user@host 'DISPLAY=:0 notify-send "TEST MESSAGE."');


}
$sth->finish;
$dbh->disconnect();

close OF;


