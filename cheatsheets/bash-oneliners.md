## Kill many processes

One's I started hylafax with deamontools and it started many procceses. `killall hfaxd` did't work.

To kill all processes use the command

    ps -acx | grep hfaxd | awk '{print $1}' | xargs kill

## Remove many file in a directorie

When there are many thousand of files in a directory you can't remove them with 'rm *'. But the next command can.

    cd directorie; for f in * ; do rm -rf $f ; done

## mail commandline

### How to delete root user’s mail

    > /var/spool/mail/root

### Zip a file and emails them to someone

    gzip -c FILENAME |uuencode FILENAME.gz | mail -s "SUBJECT" someone@domain.nl

## Testing the load/response on a website

    for i in `jot 5000` ; do wget --save-headers http://www.filmer.nl/ ; done

## File change commands

Changing Permissions Recursively. Be sure to be in the right directorie, **be gareful !!!!**  .
Gives write permissons for files and directories for group

    find ./www/ -type f -exec chmod 664 {} ;
    find ./www/ -type d -exec chmod 775 {} ;
    find ./www/ -exec chown nobody:users {} ;

### Change all the phpfiles with the content 'huisNrToe' to 'huis_nr_toe'

    find ./dirname -name "*.php" | xargs perl -pi -e 's/huisNrToe/huis_nr_toe/g'

### The 'i' option does a case-insensitive pattern matching (there much are more options).

    find ./dirname -name "*.php" | xargs perl -pi -e 's/houseNrTo/house_nr_to/gi'

### Add something to the end of each line in a file:

    cat filename.txt | sed 's/$/something/g' > newfile.txt

### Reformat DOS text files to Unix ones (the ^M chars)

    tr -d '
' < dos-text-file > unix-file

### Remove all text between the Quotes (").

    perl -p -i.bak -e 's/""(.*)""//g' example.txt

## Rename files

Rename files recursive

    find path/to/many/dirs/ -iname "*css.scss*" | sed -e "p;s/.css.scss/.scss/" | xargs -n2 mv

### If you have many files in your directory and you want to rename them with numbering.

    i=1;for f in Picture*.png ;do mv "$f" "Picture_$i.png" ;((i++));done

Heres how to add a t_ to all the .jpg files in the current directory:
(Remember to remove the "echo" if you like the results.)

    for i in *jpg ;do echo mv -i -- "./$i" "./t_${i}" ;done

If that looks good.. then remove the "echo" to make the changes permanent. <br>
(Remember to remove the first "echo" if you like the results.)

Heres how to change those t_ files to tn_ files:

    for i in t_* ;do echo mv $i `echo $i |sed 's/^t_/tn_/'` ;done


Remove a t_ from the files starting with t_

    for i in t_*jpg ;do j=`echo $i |sed 's/t_//'` ; echo mv -i -- "./$i" "./$j" ;done


Change all the .JPG files to .jpg<br>
(Remember to remove the "echo" if you like the results.)

    for i in *JPG ;do j="`echo ./$i |sed 's/JPG$/jpg/'`" ;mv -i -- "./$i" "./$j" ;done


Rename spaces in filenames to _ <br>
Example: pretty girl.jpg to pretty_girl.jpg<br>
(Remember to remove the "echo" if you like the results.)

    for i in ** ;do j="`echo ./$i |sed 's/JPG$/jpg/'`" ;mv -i -- "./$i" "./$j" ;done

## Find

### Delete using xargs:

    find . -name "*.old" -print0 | xargs -0 rm

### Find files who have been modified one day (24 hours) ago.

    find ~ -type f -mtime 1 -ls | less

### Find files older than -x (-1) days created and show this with date and time

    find /directorie/ -type f -ctime -1 -ls | awk '{print $8 "" $9 "" $10 "" $11 " (" $7 ")" }'

### Seach files for a certain word or phrase within the files:

    find . -type f -name '*.txt' -print0 | xargs -0 grep -r -i 'some.*thing'

### Find files with 'sometext' who a not in de Sent Items map.

    find . -type f ! -regex '.*/.Sent*.*' -print0 | xargs -0 grep -r -i 'sometext'

### Remove files older then 3 days

    find /tmp/mydir/ -type f ! -atime -3d -print0 | xargs -0 rm

### Find and remove small files

    find /backup/tarballs/ -type f -exec ls -s {} ; | sort -n  | head -10 | xargs -0 rm

### If you want to find all your writable directories, issue:

    find / -perm -0777 -type d -ls

### Find all media outside 'Photo Library' directory

    find /path/to/media -name '*iPhoto Library*' -prune -o -iregex ".*(jpg|dv|avi|mp3)$" | less


## Mix

Some mixed oneliners

### Manupulate numbers

Make the phone/faxnumbers unique and remove 06,084 and 087 numbers Also remove the DOS returns (^M)

    sort -u numbers.txt | sed '/^06/d' | sed '/^084/d' | sed '/^087/d' | tr -d '' > numbers2.txt

### Randomize the numbers from a text file.

    perl -e 'print map {$_->[1]} sort {$a->[0]<=>$b->[0]} map {[rand,$_]} <>' numbers2.txt > numbers3.txt

## SSH copy public key

    cat ~/.ssh/id_dsa.pub | ssh you@other-host 'cat >> ~/.ssh/authorized_keys'

## Analyse logs

### Which website uses most hits

    ls -al /var/log/hostlog | awk '{ print $5 "   " $8}' | sort -g

### Which user has succesfully logged in on "Jun 04"?

    cat /var/log/proftpd/proftpd.log | grep "Jun 04" | grep USER |  grep Login | awk ' {print $8 " " $9 }' | sort -u

### Show the hits from the logfile

    cut -f1 -d ' ' /var/log/httpd-access.log | sort | uniq -c > hits.txt

Say you have a file:row that is setup like "username|adres|domain"<br>
That file consits of 3 fields (providing there are no spaces in a field!)<br>
So say you wanted to create a new file with ONLY the email address, you could do:

    cat filename.txt | awk '{print $1'@'$3}' > newfile.txt


