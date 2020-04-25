# Linux Tools

Some uncommon tools and programs for GNU Linux not default on a system.

## Commandline

### Broot
Must have! Get an overview of a directory with search and more.

If you want to start navigating with a view of the files which changed in a git repository.

   br -gc :gs

* <https://dystroy.org/broot/>

### inxi
Analyse linux hardware with inxi

    inxi -h

### NCurses Disk Usage
Which directories are using space

    sudo apt install ncdu
    ncdu -x /

### Find duplicated files on a file system

    sudo apt-get install fdupes

### Mount iso files

    sudo apt-get install fuseiso
    sudo mkdir /media/fuseiso
    sudo fuseiso myisofile.iso /media/fuseiso

## GUI
### Unison File Synchronizer

Unison is a file-synchronization tool for Unix and Windows. It allows two replicas of a collection of files and directories to be stored on different hosts (or different disks on the same host), modified separately, and then brought up to date by propagating the changes in each replica to the other.

* [Unison](http://www.cis.upenn.edu/~bcpierce/unison)
* [ What are the differences between Unison and rsync](http://alliance.seas.upenn.edu/~bcpierce/wiki/index.php?n=Main.UnisonFAQGeneral)

### regexxer
Just found a new tool called regexxer, im sure it has been around for a while but I just discovered it. regexxer is a nifty GUI search/replace tool featuring Perl-style regular expressions. If you need project-wide substitution and youre tired of hacking sed command lines together, then you should definitely give it a try.

    sudo apt-get install regexxer

* Or online [rubular](http://rubular.com/) ruby regex

### Agave
Colorpicker en Kleurenschema's ontwerpen with [Colorscheme](http://home.gna.org/colorscheme/)

### Asciiart
FIGlet - display large characters made up of ordinary screen characters

    sudo apt-get install figlet

Very handy to make a plaintext signature.
