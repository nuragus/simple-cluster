#!/bin/bash

checkhost=192.168.56.1
count=$( ping -c 1 $checkhost | grep ttl | wc -l );

if [ $count -eq 0 ];
then
        echo "1"
        RETVAL=1;
else
        echo "0"
        RETVAL=0;
fi

exit $RETVAL;

