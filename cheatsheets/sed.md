Remove lines containing PATTERN

    find . -name "*" -type f | xargs sed -i -e '/<PATTERN>/d'

Example

    find vendor/assets/js/plugins -name "*.js" -type f | xargs sudo sed -i -e '/sourceMappingURL/d'

# Some commandline examples for sed

## Managing spaces, tabs and new lines

Delete leading whitespace (spaces/tabs) from front of each line (this aligns all text flush left). '^t' represents a true tab character. Under bash or tcsh, press Ctrl-V then Ctrl-I.

Delete trailing whitespace (spaces/tabs) from end of each line

    sed 's/[ ^t]*$//' file               # see note on '^t', above

Delete BOTH leading and trailing whitespace from each line

    sed 's/^[ ^t]*//;s/[ ^]*$//' file    # see note on '^t', above

Removing the last three characters from every filename

    cat files | sed 's/(.*).../1/'

Removing first character from each filename/string

    cat files |sed 's/.(.*)/1/'

Under UNIX: convert DOS newlines (CR/LF) to Unix format

    sed 's/.$//' file        # assumes that all lines end with CR/LF
    sed 's/^M$// file        # in bash/tcsh, press Ctrl-V then Ctrl-M

Under DOS: convert Unix newlines (LF) to DOS format

    sed 's/$//' file         # method 1
    sed -n p file            # method 2

Delete all CONSECUTIVE blank lines from file except the first.
This method also deletes all blank lines from top and end of file. (emulates "cat -s")

    sed '/./,/^$/!d' file    # this allows 0 blanks at top, 1 at EOF
    sed '/^$/N;/$/D' file    # this allows 1 blank at top, 0 at EOF

Delete all leading blank lines at top of file (only).

    sed '/./,$!d' file

Delete all trailing blank lines at end of file (only).

    sed -e :a -e '/^*$/{$d;N;};/$/ba' file

Delete leading whitespace (spaces, tabs) from front of each line aligns all text flush left

    sed 's/^[ 	]*//' # see note on '	' at end of file

Delete trailing whitespace (spaces, tabs) from end of each line

    sed 's/[ 	]*$//' # see note on '	' at end of file

Delete BOTH leading and trailing whitespace from each line

    sed 's/^[ 	]*//;s/[ 	]*$//'

If a line ends with a backslash, join the next line to it.

    sed -e :a -e '/\$/N; s/\//; ta' file

If a line begins with an equal sign, append it to the previous line (and replace the "=" with a single space).

    sed -e :a -e '$!N;s/=/ /;ta' -e 'P;D' file


## Center all text in the middle

Center all text in the middle of 79-column width.

In method 1, spaces at the beginning of the line are significant, and trailing spaces are appended at the end of the line. 

    sed -e :a -e 's/^.{1,77}$/ & /;ta'

In method 2, spaces at the beginning of the line are discarded in centering the line, and no trailing spaces appear at the end of lines.

    sed -e :a -e 's/^.{1,77}$/ &/;ta' -e 's/( *)1/1/'

Print only lines of less than 65 characters

    sed -n '/^.{65}/!p' # method 1, corresponds to above
    sed '/^.{65}/d' # method 2, simpler syntax

## Search and replace

Substitute "foo" with "bar" on each line

    sed 's/foo/bar/' file        # replaces only 1st instance in a line
    sed 's/foo/bar/4' file       # replaces only 4th instance in a line
    sed 's/foo/bar/g' file       # replaces ALL instances within a line

Substitute "foo" with "bar" ONLY for lines which contain "baz"

    sed '/baz/s/foo/bar/g' file

## EMAIL

Get Usenet/e-mail message header. Deletes everything after first blank line.

    sed '/^$/q'

Get Usenet/e-mail message body. Deletes everything up to first blank line

    sed '1,/^$/d'

Get Subject header, but remove initial "Subject: " portion

    sed '/^Subject: */!d; s///;q'

Get return address header

    sed '/^Reply-To:/q; /^From:/h; /./d;g;q'

Parse out the address proper. Pulls out the e-mail address by itself from the 1-line return address header (see preceding script).

    sed 's/ *(.*)//; s/>.*//; s/.*[:<] *//'

Add a leading angle bracket and space to each line (quote a message).

    sed 's/^/> /

Delete leading angle bracket & space from each line (unquote a message).

    sed 's/^> //'

Remove most HTML tags (accommodates multiple-line tags).

    sed -e :a -e 's/<[^<]*>/ /g;/</{N;s// /;ba;}'

Extract multi-part uuencoded binaries, removing extraneous header info, so that only the uuencoded portion remains. Files passed to
sed must be passed in the proper order. Version 1 can be entered from the command line; version 2 can be made into an executable
Unix shell script (Modified from a script by Rahul Dhesi).

    sed '/^end/,/^begin/d' file1 file2 ... fileX | uudecode
    sed '/^end/,/^begin/d' $* | uudecode


## Sources

* [no link tekst](http://www.student.northpark.edu/pemente/sed/sedfaq3.html)
* [Sed onliners](http://www.unixguide.net/unix/sedoneliner.shtml)

