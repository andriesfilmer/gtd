#!/bin/sh

echo "Create a backup using tar";

show_usage()
{
    echo "Usage: "`basename $0`" [OPTION]... <object_to_store> [dest_directory]";
    echo "Option -h for help";
}

show_help()
{
    show_usage;
    echo;
    echo "  -h              Show this help";
    echo "  -t, --tar       Uses tar without compression";
    echo "  -z, --gzip      Uses tar with compression";
    echo "  -g, --gzip      Uses tar with gzip compression (default)";
    echo "  -j, --bzip2     Uses tar with bzip2 compression";
}



####
# Default vars
####

C_COMMAND="| gzip";
C_OPTIONS=">";
EXT=".tar.gz";

# ???
#CORES=$(( $(lscpu | awk '/^Socket/{ print $2 }') * $(lscpu | awk '/^Core/{ print $4 }') ));



####
# Check
####

# from http://mywiki.wooledge.org/BashFAQ/035

# var to find
FROMPATH="";
DEST_DIR="";

while test $# -gt 0
do
    case "$1" in
        -h | -\? | --help )
            show_help;
            exit 0;
            ;;
        -t | --tar )
            C_COMMAND="";
            C_OPTIONS=">";
            EXT=".tar";
            shift;
            ;;
        -z | --gzip )
            C_COMMAND="| gzip";
            C_OPTIONS=">";
            EXT=".tar.gz";
            shift;
            ;;
        -g | --gzip )   # default
            shift;
            ;;
        -j | --bzip2 )
            C_COMMAND="| bzip2";
            C_OPTIONS=">";
            EXT=".tar.bz2";
            shift;
            ;;
        *)
            if test -z "${FROMPATH}"
            then
                FROMPATH="$1";
            elif test -z "${DEST_DIR}"
            then
                DEST_DIR="$1";
            else
                show_usage >&2;
                exit 1;
            fi;
            shift;
            ;;
    esac;
done;



if test -z "${FROMPATH}"
then
    show_usage >&2;
    exit 2;
fi;

if test -z "${DEST_DIR}"
then
    DEST_DIR=".";
elif test ! -d "${DEST_DIR}"
then
    echo "dest_directory must exists" >&2;
    exit 3;
fi;



####
# Execute
####

# define a name
FROMFILE=`echo ${FROMPATH} | awk 'BEGIN {FS="/"} {print $(NF)}'`;

if test "${FROMFILE}" = ""
then                    # if $? is empty then "$1" end with /, so
    FROMFILE=`echo ${FROMPATH} | awk 'BEGIN {FS="/"} {print $(NF-1)}'`;
fi;

TOFILE="${DEST_DIR}/${FROMFILE}_"`date +%Y-%m-%d`"${EXT}";
TOFILETXT="${DEST_DIR}/${FROMFILE}_"`date +%Y-%m-%d`".txt";

# add a timestamp if file already exist
if test -f "${TOFILE}"
then
    TOFILE="${DEST_DIR}/${FROMFILE}_"`date +%Y-%m-%d`"${EXT}";
fi;

FROMSIZE=`du -sk ${FROMPATH} | cut -f 1`;
CHECKPOINT=`echo ${FROMSIZE}/50 | bc`;

# compress
echo tar -cf - "${FROMPATH}" ${C_COMMAND} ${C_OPTIONS} "${TOFILE}";
echo "Estimated: [==================================================]";
echo -n "Progess:   [";
eval tar -c --record-size=1K --checkpoint="${CHECKPOINT}" --checkpoint-action="ttyout=\>" -f - "${FROMPATH}" ${C_COMMAND} ${C_OPTIONS} "${TOFILE}";
test "$?" -ne 0 && { echo -e "\nError, exit." >&2 ; exit 4; };
echo "]"

echo "Create a file with all the file names for easy search";
find "${FROMPATH}" -type f -exec du -h {} \; > "${TOFILETXT}";

# Show the result
echo "Create tarball -> ${TOFILE}";
echo "Create textfile-> ${TOFILETXT}";

