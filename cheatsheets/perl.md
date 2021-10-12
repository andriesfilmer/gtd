## Perl Tutorial

* <https://www.tutorialspoint.com/perl/>

## Install modules

Default install on Ubuntu

    cpan install Module::Name

If a module is missing you can install it like:

    perl -MCPAN -e 'install PDF::API2'

Hint: you can find the module-names on http://search.cpan.org/

Sometimes the install command doesn't work.

    perl -MCPAN -e 'install LWP::UserAgent'
    Can't locate object method "install" via package "LWP::UserAgent" at -e line 1.

If this happens enter the CPAN shell and give the command there

    perl -MCPAN -eshell
    cpan> install LWP::UserAgent

## Install DBI

    apt-get install build-essential
    apt-get install libdbd-mysql-perl
    perl -MCPAN -e 'install DBD::mysql'

## Check if the syntax of a perl script is ok.

    perl -w -c script.pl

## Change content in multiple files

    find dir/ -type f | xargs perl -pi -e 's/sometext/othertext/g'

Remove spaces between digits

    # Phonenumber +31 06 123 456 789 -> +3106123456789
    #
    find . -name '*.txt     ' | xargs perl -pi -e 's(d+)s+(?=d)/$1/g'

## Encode a string to base64

    perl -e 'use MIME::Base64; print encode_base64("andries@filmer.nl");'
    perl -e 'use MIME::Base64; print encode_base64("mypassword");'
