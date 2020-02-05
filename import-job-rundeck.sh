#!/bin/bash

PROJECT=$1
TOKEN=$2
HOSTNAME="prod-rundeck001.net"
URL="http://$HOSTNAME:4440/api/23/project/$PROJECT/jobs/import?fileformat=yaml"
CURL_OUT=/tmp/curl.out.$$
DIR=$(cd `dirname $0` && pwd )

CONT=0
for JOB in $DIR/*.yml
do
    curl $URL -H "Accept: application/xml" -H "X-Rundeck-Auth-Token:$TOKEN" -F "xmlBatch=@$JOB" -o $CURL_OUT 
    for ID in $(xmlstarlet sel -t -m "//job/name" -v . -n ${CURL_OUT})
    do
	echo "Job Implantado: $ID"
	CONT=$((CONT+1))
    done		
done

#url $URL -H "Accept: application/xml" -H "X-Rundeck-Auth-Token:$TOKEN" -F "xmlBatch=@$DIR/file.yml" -o $CURL_OUT >/dev/null 2>&1 
#curl $url -H "Accept: application/yaml" -F "xmlBatch=@$DIR/file.yml" -H "X-Rundeck-Auth-Token:$token"
