#!/bin/bash

status=`systemctl status logstash.service | awk 'NR==3' | awk '{print $2}'`

if [ $status == "active" ]; then
        echo "OK"
        exit 0
else
        echo "Logstash indisponivel"
        exit 1
fi
