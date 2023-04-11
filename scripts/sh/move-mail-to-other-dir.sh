#!/bin/bash
for i in $(find Your_Mail_Dir/ -newermt "2023-01-01" ! -newermt "2023-12-31"); do
  mv $i /moved_emails_dir/
done
