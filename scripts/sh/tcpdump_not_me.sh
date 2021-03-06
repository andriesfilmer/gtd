#!/bin/sh

# Show all network traffic except that for the current ssh connection
# This allows running tcpdump remotely over ssh.

# Author:
#    http://www.pixelbeat.org/
# Notes:
#    Some configurations of sudo strip the environment,
#    so to run under sudo in that case do:
#      sudo env SSH_CLIENT="$SSH_CLIENT" tcpdump_not_me
# Changes:
#    V0.1, 22 Apr 2005, Initial release
#    V0.2, 28 Aug 2009, Shai Ben-Naphtali <shai@shaibn.com>
#                         Handle new format $SSH_CLIENT

if [ "$SSH_CLIENT" ]; then
  expression=$(
    echo "$SSH_CLIENT" |
    sed 's/.*://;
         s/^\([0-9.]*\) [0-9]* \([0-9]*\)$/not \( host \1 and port \2 \)/'
  )
fi
tcpdump "$@" $expression

