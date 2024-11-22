# Linux tools - Not default on the system

Some uncommon tools and programs for GNU Linux not default on a system.

## Commandline

### PDF
Extract page 12-15

    pdftk full-pdf.pdf cat 12-15 output outfile_p12-15.pdf

### Miller
Miller is a command-line tool for querying, shaping, and reformatting data files in various formats including CSV, TSV, JSON, and JSON Lines.

 sudo apt install miller

### inxi

Analyse linux hardware with inxi

    inxi -h

### NCurses Disk Usage

Which directories are using space

    sudo apt install ncdu
    ncdu -x /

### Find duplicated files on a file system

    sudo apt install fdupes

### Mount iso files

    sudo apt install fuseiso
    sudo mkdir /media/fuseiso
    sudo fuseiso myisofile.iso /media/fuseiso

## GUI

### Disk Usage Analyzer (also known as baobab)

Keep your disk usage under control

### Unison File Synchronizer

Unison is a file-synchronization tool for Unix and Windows. It allows two replicas of a collection of files and directories to be stored on different hosts (or different disks on the same host), modified separately, and then brought up to date by propagating the changes in each replica to the other.

* [Unison](http://www.cis.upenn.edu/~bcpierce/unison)
* [ What are the differences between Unison and rsync](http://alliance.seas.upenn.edu/~bcpierce/wiki/index.php?n=Main.UnisonFAQGeneral)

### regexxer

Just found a new tool called regexxer, im sure it has been around for a while but I just discovered it. regexxer is a nifty GUI search/replace tool featuring Perl-style regular expressions. If you need project-wide substitution and youre tired of hacking sed command lines together, then you should definitely give it a try.

    sudo apt install regexxer

* Or online [rubular](http://rubular.com/) ruby regex

### Agave

Colorpicker and colorschemes designed with [Colorscheme](http://home.gna.org/colorscheme/)

### Asciiart

FIGlet - display large characters made up of ordinary screen characters

    sudo apt install figlet

Very handy to make a plaintext signature.
