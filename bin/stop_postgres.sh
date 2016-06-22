#!/bin/bash

# Stopping DB. Containing:
#  - Stopping the floating ip address
#  - Stopping postgres database
#  - Dismounting filesystem

# Read configuration file
source ../settings.cfg;

timestamp=$(date +%d%m%Y-%T);
printf "%s : stopping postgres\n" $timestamp >> $log_directory/shutdown.log

# Stopping floating ip
timestamp=$(date +%d%m%Y-%T);
ifconfig $floating_device down > /dev/null;
if [ $? == "0" ]; then
  printf "%s : success deactivating floating ip\n" $timestamp >> $log_directory/shutdown.log;
else
  printf $timestamp"%s : failed deactivating floating ip\n" $timestamp >> $log_directory/shutdown.log;
fi

#Stopping postgres database
/bin/su -l postgres -c 'source ~/pg_env.sh; pg_ctl -D $PGDATA stop -m fast' > /dev/null;
if [ $? == "0" ]; then
  printf "%s : success stopping postgres\n" $timestamp >> $log_directory/shutdown.log;
else
  printf "%s : failed deactivating floating ip\n" $timestamp >> $log_directory/shutdown.log;
fi

#Dismounting filesystem
umount /postgres > /dev/null;
if [ $? == "0" ]; then
  printf "%s : success dismounting postgres filesystem\n" $timestamp >> $log_directory/shutdown.log;
else
  printf "%s : failed dismounting floating ip\n" $timestamp >> $log_directory/shutdown.log;
fi
