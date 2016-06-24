#!/bin/bash

this_host=`hostname`

source $main_directory/settings.cfg;
echo $pg_exec;

count=$( for i in {1..5}; do $pg_exec/psql -U job-bpm -d job-bpm -h $floating_ip -c 'select COUNT(*) FROM bpm_config'; done | grep row | wc -l ) > /dev/null;
timestamp=$(date +%d%m%Y-%T);


if [ $count -lt 3 ];
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
		echo "1" > /$db_directory/i_was_ownerdb;
	fi
  echo $timestamp >> /$db_directory/checkdb.log;
  echo "the database is running at:"$owner >> /$db_directory/checkdb.log;
        RETVAL=0;
fi

exit $RETVAL;

