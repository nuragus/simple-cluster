#!/bin/bash

file="/cluster/obor/postgres/data/postmaster.pid";
#stop db
/bin/su -l postgres -c 'pg_ctl -D $PGDATA stop -m fast'

#kill db
cat "$file" | head -1 | xargs kill -9

#delete pid file
rm /postgres/postgresql/9.4/data/postmaster.pid

#umount force
umount -ldf /postgres

#cabut ip vir
ifconfig eth5:1 down

