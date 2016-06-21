#!/bin/bash
# check_ip.sh
# Pinging reference IP to know network status

# Read configuration file
source ../settings.cfg;

timestamp=$(date +%d%m%Y-%T);
count=$( ping -c 5 -W 1 $reference_ip | grep ttl | wc -l );

if [ $count -lt 3 ];
then
  echo "1"
  echo $timestamp": error ping reference ip" >> $log_directory/check_ip.log;
  RETVAL=1;
else
  echo "0"
  echo $timestamp": success ping reference ip" >> $log_directory/check_ip.log;
  RETVAL=0;
fi

exit $RETVAL;

