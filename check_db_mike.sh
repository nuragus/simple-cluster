#!/bin/bash

target=192.168.56.105;
this_host=`hostname`
#count=$( for i in {1..5}; do nc -w 1 -z 192.168.1.105 5432; done | grep succeeded | wc -l );
#count=$( for i in {1..5}; do pg_isready -h 192.168.1.105 -p 5432; done | grep accept | wc -l );
count=$( for i in {1..5}; do psql -U job-bpm -d job-bpm -h 192.168.56.105 -c 'select CAST(COUNT(*) AS BIT) FROM bpm_config'; done | grep 0 | wc -l ) > /dev/null;
timestamp=$(date +%d%m%Y-%T);


if [ $count -lt 3 ];
then
  echo $timestamp >> /bpm/scripts/checkdb.log;
  echo "the database is not running" >> /bpm/scripts/checkdb.log;
  echo "1"
  RETVAL=1;
else
  owner=`ssh hant00@192.168.56.105 "hostname"`;
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

