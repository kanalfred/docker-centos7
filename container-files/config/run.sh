#!/bin/bash

# custom script 

# start up daemons
/usr/bin/supervisord -n -c /etc/supervisord.conf
