#!/bin/bash

target=192.168.56.105;
this_host=`hostname`
count=$( for i in {1..10}; do nc -w 1 -z 192.168.56.105 5432; done | grep succeeded | wc -l );

if [ $count -lt 5 ];
then
  echo $timestamp >> /bpm/scripts/checkdb.log;
  echo "the database is not running" >> /bpm/scripts/checkdb.log;
  echo "1"
        RETVAL=1;
else
        owner=`ssh root@192.168.56.105 "hostname"`;
	echo "0";
	if [ $owner == $this_host ];
	then
		echo "0" > /bpm/scripts/i_was_owner;
	else
		echo "1" > /bpm/scripts/i_was_owner;
	fi
  echo $timestamp >> /bpm/scripts/checkdb.log;
  echo "the database is running at:"$owner >> /bpm/scripts/checkdb.log;
        RETVAL=0;
fi

exit $RETVAL;

