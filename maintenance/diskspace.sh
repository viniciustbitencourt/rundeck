#!/bin/bash

porc=$1
df -H | grep -vE '^Filesystem|tmpfs' | awk '{print $5 " " $6}' | while read output;
do
        echo $output
        uso=$(echo $output | awk '{print $1}' | cut -d'%' -f1)
        particao=$(echo $output | awk '{print $2}')
        if [ $uso -ge $porc ]; then
                echo "Espaco em disco no \"$particao ($uso%)\" em uso"
                exit 1
        fi
done
