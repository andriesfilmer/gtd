#!/bin/sh


path="~/gtd/"

#myexe="find $path -type f -print0 | xargs -0 grep -r -i $files $1"
#node ~/gtd/scripts/node/md-add-toc.js ~/gtd/resources/javascript-frameworks.md


if [ $1 ]; then

    echo "Making toc for $1"
    node ~/gtd/scripts/node/md-add-toc.js ~/gtd/resources/javascript-frameworks.md

else

  echo
  echo "usage  : mysearch.sh <sometext>  < d | s | h >  [ f ]"
  echo "example: mysearch.sh "Rabobank Zandvoort" d f"

fi

