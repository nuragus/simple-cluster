#!/bin/bash

mount /postgres

#add ip vir
ifconfig eth5:1 192.168.56.105 netmask 255.255.255.0

#start db
/bin/su -l postgres -c 'pg_ctl -D $PGDATA start'
