#!/bin/bash

#stop db
/bin/su -l postgres -c 'pg_ctl -D $PGDATA stop -m fast'
rm /postgres/postgresql/9.4/data/postmaster.pid

#cabut ip vir
ifconfig eth5:1 down

umount /postgres
