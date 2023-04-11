#!/bin/bash
for i in $(find path/to/images/ -type f -size +500k); do
  echo "mogrify -resize 500x500" $i
  mogrify -resize 500x500 $i
done
