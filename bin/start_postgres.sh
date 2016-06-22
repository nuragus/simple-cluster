#!/bin/bash

# Starting UP DB. Containing:
#  - Mount the disk; The disk must be set in /etc/fstab, and configured in settings.cfg as postgres_mount parameter
#  - Activate floating IP address
#  - Start Postgres

# Read configuration file
source ../settings.cfg;


printf "%s : starting up database package" $timestamp >> $log_directory/startup.log;

# Mounting postgres
timestamp=$(date +%d%m%Y-%T);
mount $postgres_mount > /dev/null 2>&1;
if [ $? == "0" ]; then
  printf "%s : success mounting postgres" $timestamp >> $log_directory/startup.log;
else
  printf "%s : failed mounting postgres" $timestmp >> $log_directory/startup.log;
fi

# Activate floating IP
timestamp=$(date +%d%m%Y-%T);
ifconfig $floating_device $floating_ip netmask $floating_netmask > /dev/null;
if [ $? == "0" ]; then
  printf "%s : success activating floating ip" $timestamp >> $log_directory/startup.log;
else
  printf "%s : failed activating floating ip" $timestamp >> $log_directory/startup.log;
fi

# Starting up database
/bin/su -l postgres -c 'source ~/pg_env.sh; pg_ctl -D $PGDATA start' > /dev/null
if [ $? == "0" ]; then
  printf "%s : success starting up database" $timestamp >> $log_directory/startup.log;
else
  printf "%s : failed starting up database" $timestamp >> $log_directory/startup.log;
fi
