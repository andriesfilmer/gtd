#!/bin/sh

path="/usr/local/vpopmail/domains/filmer.nl/andries/Maildir/"

# Do we need to searh to,from,subject?
#
case "$3" in

   from|From)
      q="^From:.*$1*" 
   ;;

   to|To)
      q="^To:.*$1*" 
   ;;   

   subject|Subject)
      q="^Subject:.*$1*" 
   ;;

   all|*)
      q="$1" 
   ;;

esac

# Do we need to print the filenames?
#
if [ $4 ]; then

   files="-H"

else

   files="-h"

fi


# We Know what to do so we find some mailmessages
#
case "$2" in

   s|send)

          echo "finding files in Sent mail...... "
          find $path -type f -regex '.*/.Sent*.*' -print0 | xargs -0 grep -r -i $files "$q"

      ;;

   r|received)

         echo "finding files in Recieved mail....."
         find $path -type f \! -regex '.*/.Sent*.*' -print0 | xargs -0 grep -r -i $files "$q"

      ;;

   *)

      echo
      echo "usage  : findMail.sh <sometext> <send | s | [ received | r>   [ from | to | subject | all ]  [ f | filename ]"
      echo "example: findMail.sh "Webmaster Mycom" r  from f"
      echo
      ;;

esac
