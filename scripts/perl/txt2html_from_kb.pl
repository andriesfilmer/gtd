#!/usr/bin/perl 

use HTML::TextToHTML;
use DBI;

# DB Vars
#
$dbuser = "";
$dbhost = "mysql.filmer.nl";
$dbpass = "xxxxxxxx";
$db     = "database";
$dbi    = "DBI:mysql:$db:$dbhost";

# Connect to the database
#
$dbh=DBI->connect("$dbi","$dbuser","$dbpass") || die "Cannot connect to db server DBI::errstr,\n";

$sqlstr = "     SELECT title,description,keywords,lang,created,updated,pageBody
		FROM kb WHERE public='1'";

# Fetch domain-data
#
$sth=$dbh->prepare($sqlstr);
$sth->execute || die "Lost connection to db server DBI::errstr,\n";

# create a new object
#
my $conv = new HTML::TextToHTML();

while ( ($title,$description,$keywords,$lang,$created,$updated,$pageBody) = $sth->fetchrow_array ) 
{
	# Add arguments
        #
	$conv->args(titlefirst=>1,
                    preformat_whitespace_min=>2,
                    preformat_trigger_lines=>1,
                    make_tables=>1);

	$html = $conv->process_chunk($pageBody);

	$page = $title;
	$page =~ s/[^A-Za-z0-9\s]//sg;
	$page =~ s/\s+/_/g;

	open HTML, ">/home/www/kb.filmer.nl/$lang/$page.html";
	print HTML "<\!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01//EN' 'http://www.w3.org/TR/html4/strict.dtd'>\n";
	print HTML "<head>\n";
	print HTML "<title>$title</title>\n";
	print HTML "<META name='Author' content='Andries Filmer'>\n";
	print HTML "<META name='Description' content='$description'>\n";
	print HTML "<META name='keywords' content='$keywords'>\n";
	print HTML "<link rel='stylesheet' href='/shared/style.css' />\n";
	print HTML "</head>\n";
	print HTML "<body>\n";

	print HTML "<h1>$title</h1>\n";
	print HTML "<div id='description'>$description</div>\n";
	print HTML "<div id='pageBody'>$html</div>\n";
	#print HTML "$html\n";

	if ($lang eq "NL")
	{
		print HTML "<TABLE><THEAD><TR><TH>Schrijver: Andries Filmer</TH><TH>Gemaakt: $created</TH><TH>Aangepast: $updated</TH></TR></THEAD></TABLE>\n";
	}
	else
	{
		print HTML "<TABLE><THEAD><TR><TH>Author: Andries Filmer</TH><TH>Created: $created</TH><TH>Updated: $updated</TH></TR></THEAD></TABLE>\n";
	}
	print HTML "</html>\n";
	print HTML "</body>\n";
	close HTML;
}

