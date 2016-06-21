#!/bin/bash

# Starting UP DB. Containing:
#  - Mount the disk; The disk must be set in /etc/fstab, and configured in settings.cfg as postgres_mount parameter
#  - Activate floating IP address
#  - Start Postgres

# Read configuration file
source ../settings.cfg;

timestamp=$(date +%d%m%Y-%T);

echo $timestamp": starting up database package" > $log_directory/startup.log;

# Mounting postgres
mount $postgres_mount > /dev/null 2>&1;
if [ $? == "0" ]; then
  echo $timestamp": success mounting postgres" >> $log_directory/startup.log;
else
  echo $timestamp": failed mounting postgres" >> $log_directory/startup.log;
fi

# Activate floating IP
ip_exec="ifconfig "$floating_device" "$floating_ip" netmask"$floating_netmask;
echo $ip_exec;
#ifconfig $floating_device $floating_ip netmask $floating_netmask > /dev/null;
if [ $? == "0" ]; then
  echo $timestamp": success activating floating ip" >> $log_directory/startup.log;
else
  echo $timestamp": failed activating floating ip" >> $log_directory/startup.log;
fi

# Starting up database
/bin/su -l postgres -c 'source ~/pg_env.sh; pg_ctl -D $PGDATA start' > /dev/null
if [ $? == "0" ]; then
  echo $timestamp": success starting up database" >> $log_directory/startup.log;
else
  echo $timestamp": failed starting up database" >> $log_directory/startup.log;
fi
