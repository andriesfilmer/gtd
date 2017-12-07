#!/usr/bin/awk -f
BEGIN {
        for(i=0;i<240;i++)
                printf"0%3d %c\n",i,i
}
