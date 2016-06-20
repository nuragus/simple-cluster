#!/bin/bash

checkip=`/bpm/scripts/check_ip.sh`;
checkowner=`cat /bpm/scripts/i_was_owner`;
thishost=`hostname`;
timestamp=$(date +%d%m%Y-%T);

echo $timestamp >> /bpm/scripts/reloc.log;

if [ $checkip == "0" ]; then
  if [ $checkowner == "0" ]; then
    echo "i was the owner; sleeping for 1 minute before mounting and startup postgres" >> /bpm/scripts/reloc.log;
    for i in {1..10}; do
      if [ `/bpm/scripts/check_db.sh` == "0" ]; then
        echo "the database is running! probably at the other node" >> /bpm/scripts/reloc.log;
        exit 0;
      fi
	echo "still sleeping... preventing split brain" >> /bpm/scripts/reloc.log;
	sleep 1;
    done;
    if [ `/bpm/scripts/check_db.sh` == "1" ]; then
       echo "after sleeping 1 minute , postgres still down; starting up here" >> /bpm/scripts/reloc.log;
       exec "/bpm/scripts/start_db.sh";
    fi
  else
    echo "i was not the owner, seems i can start now" >> /bpm/scripts/reloc.log;
    if [ $thishost == "node1" ]; then
      ssh root@node2 /bpm/scripts/cleanup_db.sh;
    elif [ $thishost == "node2" ]; then
      ssh root@node1 /bpm/scripts/cleanup_db.sh;
    fi	
    exec "/bpm/scripts/start_db.sh";
  fi
else
  echo "my network is problem; do nothing to prevent split brain; need human intervention" >> /bpm/scripts/reloc.log;
fi
