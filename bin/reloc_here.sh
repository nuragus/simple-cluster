#!/bin/bash

source $main_directory/settings.cfg;

checkip=`$bin_directory/check_ip.sh`;
checkowner=`cat $db_directory/i_was_owner.db`;
thishost=`hostname`;
timestamp=$(date +%d%m%Y-%T);
logfile="$log_directory/reloc.log";
start_exec="$bin_directory/start_postgres.sh";

echo $timestamp >> $log_directory/reloc.log;

if [ $checkip == "0" ]; then
  if [ $checkowner == "0" ]; then
    echo $timestamp": i was the owner; sleeping for 10 check cycles before mounting and startup postgres" >> $logfile;
    for i in {1..10}; do
      if [ `$bin_directory/check_db.sh` == "0" ]; then
        echo $timestamp": postgres is running! probably at the other node" >> $logfile;
        exit 0;
      fi
	echo $timestamp": still sleeping... preventing split brain" >> $logfile;
	sleep 1;
    done;
    if [ `$bin_directory/check_db.sh` == "1" ]; then
       echo $timestamp": after sleeping long enough, postgres still down; starting up here" >> $logfile;
       exec "$bin_directory/start_db.sh";
       echo $timestamp": now i am the owner of postgres" >> $logfile
    fi
  else
    echo "i was not the owner, seems i can start now" >> $logfile;
    if [ $thishost == "node1" ]; then
      ssh root@node2 $main_directory/stop_postgres.sh;
    elif [ $thishost == "node2" ]; then
      ssh root@node1 $main_directory/stop_postgres.sh;
    fi
    exec `$start_exec`;
  fi
else
  echo "my network is problem; do nothing to prevent split brain; need human intervention" >> $log_directory/reloc.log;
fi
