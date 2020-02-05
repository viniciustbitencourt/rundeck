#!/bin/bash

status=`systemctl status rundeckd.service | awk 'NR==3' | awk '{print $2}'`

if [ $status == "active" ]; then
        echo "OK"
        exit 0
else
        echo "Rundeck indisponivel"
        exit 1
fi
