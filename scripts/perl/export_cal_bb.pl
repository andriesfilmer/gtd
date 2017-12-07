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
use Time::Local;
use Time::localtime;
use Date::Calc qw(Delta_DHMS);

$tm = localtime;
($day, $month, $year) = ($tm->mday, $tm->mon, $tm->year);;
#$today = sprintf("%04d%02d%02d", $year+1900, $month+1, $day);
$today = sprintf("%04d%02d%02d", $year+1900, $month+1, $day);

# Connect to database
#
$dbh=DBI->connect($dbi,$dbuser,$dbpass) || die "Cannot connect to db server DBI::errstr,\n";


open OF, "> /tmp/export_cal_bb_tmp.txt";

print OF "\"Start Date\",\"Start Time\",\"End Date\",\"End Time\",\"Alarm Flag\",\"Alarm Date\",\"Alarm Time\",\"Description Title\",\"Notes\",\"Location\"\n";

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

    $dyear   = substr($cal_date,0,4);
    $dmonth  = substr($cal_date,4,2);
    $dday    = substr($cal_date,6,2);
    $dhour   = substr($cal_time,0,2);
    $dminute = substr($cal_time,2,2);
    $dsecond = "00";

    # Debug
    print "Cal_date:$cal_date CalTime:$cal_time Year:$dyear Month:$dmonth Day:$dday Hour:$dhour Min:$dminute Sec:$dsecond\n";

    # Startime in epoch seconds
    $epochStart = timelocal($dsecond, $dminute, $dhour, $dday, $dmonth, $dyear); 

    # Endtime in epoch seconds
    $epochEnd = $epochStart + ($cal_duration * 60);

    # Alarmtime in epoch seconds (half a hour)
    $epochAlarm= $epochStart - 1800;

    # Create the end date and time
    $tmend = localtime($epochEnd); 
    $tmalarm = localtime($epochAlarm); 

    # Make it the right format.
    $cal_end_date = sprintf("%04d%02d%02d", $tmend->year+1900,$tmend->mon, $tmend->mday);
    $cal_end_time = sprintf("%02d%02d", $tmend->hour,$tmend->min);
    $cal_alarm_date =sprintf("%04d%02d%02d", $tmalarm->year+1900,$tmalarm->mon, $tmalarm->mday);
    $cal_alarm_time = sprintf("%02d%02d", $tmalarm->hour,$tmalarm->min);

    print "\"$cal_date\",\"$cal_time\",\"$cal_end_date\",\"$cal_end_time\",\"$set_alarm\",\"$cal_alarm_date\",\"$cal_alarm_time\",\"$cal_name\",\"Kijk in de webcalendar.\",\"\"\n";
    print OF"\"$cal_date\",\"$cal_time\",\"$cal_end_date\",\"$cal_end_time\",\"$set_alarm\",\"$cal_alarm_date\",\"$cal_alarm_time\",\"$cal_name\",\"Kijk in de webcalendar.\",\"\"\n";

}
$sth->finish;
$dbh->disconnect();

close OF;


