#!/bin/bash

source $main_directory/settings.cfg;

target=192.168.56.105;
this_host=`hostname`
count=$( for i in {1..10}; do nc -w 1 -z -v $floating_ip 5432; done | grep succeeded | wc -l );

if [ $count -lt 5 ];
then
  echo $timestamp >> /$log_directory/checkdb.log;
  echo "the database is not running" >> /$log_directory/checkdb.log;
  echo "1"
        RETVAL=1;
else
        owner=`ssh root@$floating_ip "hostname"`;
	echo "0";
	if [ $owner == $this_host ];
	then
		echo "0" > /$db_directory/i_was_owner.db;
	else
		echo "1" > /$db_directory/i_was_owner.db;
	fi
  echo $timestamp >> /$log_directory/checkdb.log;
  echo "the database is running at:"$owner >> /$log_directory/checkdb.log;
        RETVAL=0;
fi

exit $RETVAL;

