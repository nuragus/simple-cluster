#!/bin/bash
# check_ip.sh
# Pinging reference IP to know network status
# Reference IP is being pinged 5 times. If 3 or more, it is a success. This is to allow intermittance

# Read configuration file
source /opt/simple-cluster/settings.cfg;

timestamp=$(date +%d%m%Y-%T);
count=$( ping -c 5 -W 1 $reference_ip | grep ttl | wc -l );

if [ $count -gt 2 ]; then
  printf "%d\n" 0;
  printf "%s : success ping reference ip\n" $timestamp >> $log_directory/check_ip.log;
  RETVAL=0;
else
  printf "%d\n" 1;
  printf "%s : error ping reference ip\n" $timestamp >> $log_directory/check_ip.log;
  RETVAL=1;
fi

exit $RETVAL;

