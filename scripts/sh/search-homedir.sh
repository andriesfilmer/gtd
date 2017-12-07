#!/bin/sh

path="~/docs"

# Do we need to print the filenames?
#
if [ $3 ]; then

   files="-H"

else

   files="-h"

fi

#myexe="find $path -type f -print0 | xargs -0 grep -r -i $files $1"

case "$2" in

   d)
      path="$path/mydoc"
      echo "finding files in mydocs...... "
      find $path -type f -print0 | xargs -0 grep -r -i $files "$1" 
     ;;

   s)
      path="$path/myscript"      
      echo "finding files in myscripts...... "         
      find $path -type f -print0 | xargs -0 grep -r -i $files "$1" 
      ;;

   h)
      path="$path/myhowto"
      echo "finding files in myhowto...... "
      find $path -type f -print0 | xargs -0 grep -r -i $files "$1"     
      ;;

   *)
      echo
      echo "usage  : mysearch.sh <sometext>  < d | s | h >  [ f ]"
      echo "example: mysearch.sh "Rabobank Zandvoort" d f"
      echo
      echo "d : Search only in mydocs"
      echo "s : Search only in myscripts"
      echo "h : Search only in myhowto"
      echo "f : Print also path and filename"
      echo
      ;;

esac
