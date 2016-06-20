#stop db
/bin/su -l postgres -c 'pg_ctl -D $PGDATA stop -m fast'

#cabut ip vir
ifconfig eth5:1 down

umount /postgres
#ssh ke sebelah execute script
ssh root@192.168.1.103 /bpm/scripts/updb.sh
