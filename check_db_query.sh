#!/bin/bash

target=192.168.1.105;
this_host=`hostname`
count=$( for i in {1..10}; do su - postgres -c 'psql -d job-bpm -h 192.168.1.105 -c "select count(*) from bpm_config"'; done | grep row | wc -l ) > /dev/null;

if [ $count -lt 5 ];
then
    echo "1"
        RETVAL=1;
else
        owner=`ssh hant00@192.168.1.105 "hostname"`;
	echo "0";
	if [ $owner == $this_host ];
	then
		echo "0" > /bpm/scripts/i_was_owner;
	else
		echo "1" > /bpm/scripts/i_was_owner;
	fi
#        echo $owner
        RETVAL=0;
fi

exit $RETVAL;

