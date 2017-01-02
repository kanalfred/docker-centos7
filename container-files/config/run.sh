#!/bin/bash

# custom script 

# set root password if env #ROOT_PASSWORD var is set
if [ ! -z "$ROOT_PASSWORD" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
fi

# start up daemons
/usr/bin/supervisord -n -c /etc/supervisord.conf
