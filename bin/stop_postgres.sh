#!/bin/bash

# Stopping DB. Containing:
#  - Stopping the floating ip address
#  - Stopping postgres database
#  - Dismounting filesystem

# Read configuration file
source ../settings.cfg;

# Stopping floating ip
ifconfig $floating_device down > /dev/null;
if [ $? == "0" ]; then
  echo $timestamp": success deactivating floating ip" >> $log_directory/shutdown.log;
else
  echo $timestamp": failed deactivating floating ip" >> $log_directory/shutdown.log;
fi

#Stopping postgres database
/bin/su -l postgres -c 'source ~/pg_env.sh; pg_ctl -D $PGDATA stop -m fast' > /dev/null;
if [ $? == "0" ]; then
  echo $timestamp": success stopping postgres" >> $log_directory/shutdown.log;
else
  echo $timestamp": failed deactivating floating ip" >> $log_directory/shutdown.log;
fi

#Dismounting filesystem
umount /postgres > /dev/null;
if [ $? == "0" ]; then
  echo $timestamp": success dismounting postgres filesystem" >> $log_directory/shutdown.log;
else
  echo $timestamp": failed dismounting floating ip" >> $log_directory/shutdown.log;
fi
