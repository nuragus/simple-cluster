# check_ip.sh
# Pinging reference IP to know network status

#!/bin/bash

source ../settings.cfg;

count=$( ping -c 5 -W 1 $reference_ip | grep ttl | wc -l );

if [ $count -lt 3 ];
then
        echo "1"
        RETVAL=1;
else
        echo "0"
        RETVAL=0;
fi

exit $RETVAL;

