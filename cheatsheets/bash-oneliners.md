# Bash oneliners

Nice resource: <https://www.commandlinefu.com/>

## Kill many processes

One's I started hylafax with deamontools and it started many procceses. `killall hfaxd` did't work.

To kill all processes use the command

    ps -acx | grep hfaxd | awk '{print $1}' | xargs kill

## Remove many file in a directorie

When there are many thousand of files in a directory you can't remove them with 'rm *'. But the next command can.

    cd directorie; for f in * ; do rm -rf $f ; done

### Zip a file and emails them to someone

    gzip -c FILENAME |uuencode FILENAME.gz | mail -s "SUBJECT" someone@domain.nl

## Testing the load/response on a website

    for i in `jot 5000` ; do wget --save-headers http://www.filmer.nl/ ; done

## Find commands

Find permissons on files and directories

    find /path/to/dir -perm -0777 -type d
    find /path/to/dir -not -perm 400
    find /path/to/dir -not -group sudo

Changing Permissions Recursively.

    find /path/to/dir -type f -exec chmod 664 {} \;
    find /path/to/dir -type d -exec chmod 775 {} \;
    find /path/to/dir -exec chown www-data:www-data {} \;

Find empy directories

    find . -type d -empty

Find recently modified files

    find /path/to/file -newer notes.txt
    find /path/to/dir -amin -30

Find with regular expression (files whose names start with the letter w)

    find /path/to/dir -regex "./w.*"


## Rename files

Fix some files (matching 1.png, 2.png, ... 9.png) so that they have leading zeros for proper ordering.

    for i in [1-9].png ; do mv $i 0$i ; done

If you have many files in your directory and you want to rename them with numbering.

    i=1;for f in Picture*.png ;do mv "$f" "Picture_$i.png" ;((i++));done

Rename files recursive

    find path/to/many/dirs/ -iname "*css.scss*" | sed -e "p;s/.css.scss/.scss/" | xargs -n2 mv


Heres how to add a t_ to all the .jpg files in the current directory:
(Remember to remove the "echo" if you like the results.)

    for i in *jpg ;do echo mv -i -- "./$i" "./t_${i}" ;done

If that looks good.. then remove the "echo" to make the changes permanent. <br>
(Remember to remove the first "echo" if you like the results.)

Change all the .JPG files to .jpg<br>
(Remember to remove the "echo" if you like the results.)

    for i in *JPG ;do j="`echo ./$i |sed 's/JPG$/jpg/'`" ;mv -i -- "./$i" "./$j" ;done


Rename spaces in filenames to _ <br>
Example: pretty girl.jpg to pretty_girl.jpg<br>
(Remember to remove the "echo" if you like the results.)

    for i in ** ;do j="`echo ./$i |sed 's/JPG$/jpg/'`" ;mv -i -- "./$i" "./$j" ;done

## Find

Delete files using xargs:

    find . -name "*.old" -print0 | xargs -0 rm

Find files who have been modified one day (24 hours) ago.

    find ~ -type f -mtime 1 -ls | less

Find files older than -x (-1) days created and show this with date and time

    find /directorie/ -type f -ctime -1 -ls | awk '{print $8 "" $9 "" $10 "" $11 " (" $7 ")" }'

Find files for a certain word or phrase within the files:

    find . -type f -name '*.txt' -print0 | xargs -0 grep -r -i 'some.*thing'

Find files with 'sometext' who are not in de Sent Items map.

    find . -type f ! -regex '.*/.Sent*.*' -print0 | xargs -0 grep -r -i 'sometext'

Find files older then 3 days

    find /tmp/mydir/ -type f ! -atime -3d -print0 | xargs -0 rm

Find large files

    find /path/to/ -type f -size +100M

Find and remove small files

    find /backup/tarballs/ -type f -exec ls -s {} ; | sort -n  | head -10 | xargs -0 rm

Find all media outside 'Photo Library' directory

    find /path/to/media -name '*Photo Library*' -prune -o -iregex ".*(jpg|dv|avi|mp3)$" | less

Change all the php-files with the content 'someString' to 'some_string'

    find ./dirname -name "*.php" | xargs perl -pi -e 's/someString/some_string/g'


## diff
Difference between two file directories

    diff -y <(tree app/assets/stylesheets/sites/dosc/) <(tree app/assets/stylesheets/sites/skell/)

## Find Duplicate Files (based on MD5 hash)
Calculates md5 sum of files. sort (required for uniq to work). uniq based on only the hash. use cut ro remove the hash from the result.

    find -type f -exec md5sum '{}' ';' | sort | uniq --all-repeated=separate -w 33 | cut -c 35-


## Mix

Manupulate numbers

Make the phone/faxnumbers unique and remove 06,084 and 087 numbers Also remove the DOS returns (^M)

    sort -u numbers.txt | sed '/^06/d' | sed '/^084/d' | sed '/^087/d' | tr -d '' > numbers2.txt

Randomize the numbers from a text file.

    perl -e 'print map {$_->[1]} sort {$a->[0]<=>$b->[0]} map {[rand,$_]} <>' numbers2.txt > numbers3.txt

SSH copy public key

    cat ~/.ssh/id_dsa.pub | ssh you@other-host 'cat >> ~/.ssh/authorized_keys'

