# Sum last column in file

    cat file-with-columns.txt | awk '{print $NF}' > last-column-file.txt
    awk '{s+=$1} END {print s}' last-column.file.txt


# Which ipnrs are spamming the form

    cat log/captcha.log | awk -F ',' '{print $3}' | sort | uniq -c | sort
