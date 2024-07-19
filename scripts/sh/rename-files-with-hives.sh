#!/usr/bin/bash

# Replace all file names in this directory if it contains a space or special charachter.

for file in *; do
  if [[ "$file" =~ [^a-zA-Z0-9._-] ]]; then
    mv "$file" "$(echo "$file" | tr ' ' '-' | sed 's/[^a-zA-Z0-9._-]/-/g')"
  fi
done

