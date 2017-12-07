#!/bin/sh
COUNT=0
while [ $COUNT -lt 1000 ]
do
#   echo $COUNT
   wget http://www.website.nl
   COUNT=`echo $COUNT+1 | bc`
done
