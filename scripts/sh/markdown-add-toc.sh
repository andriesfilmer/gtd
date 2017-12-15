#!/bin/sh


path="~/gtd/"

#myexe="find $path -type f -print0 | xargs -0 grep -r -i $files $1"
#node ~/gtd/scripts/node/md-add-toc.js ~/gtd/resources/javascript-frameworks.md


if [ $1 ]; then

    echo "Making toc for $1"

    # Create a toc in var
    TOC=`node ~/gtd/scripts/node/md-add-toc.js ~/gtd/$1`

    # Add TOC in toc file
    echo "$TOC" > "$1.toc"

    # Add a end toc mark 
    echo "\n<!-- END TOC -->\n" >> "$1.toc"

    # Markdown content (MD) from first # header
    MD=`sed -n '/^#/,$p' $1`

    # Add markdown to new toc file
    echo "$MD" >> "$1.toc"

    # Move new toc file to current markdown (with TOC)
    mv "$1.toc" "$1"

else

  echo
  echo "usage  : ./add-toc path_to_markdown_file"
  echo

fi

