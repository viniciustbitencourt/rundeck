#!/bin/bash

TOKEN=$1
NODE=$2
PROJECT=$3

CURL_OUT=/tmp/curl.out.$$

#URL="http://${NODE}:4440/api/24/project/Manutencao"

URL="http://${NODE}:4440/api/23/project/${PROJECT}/jobs"
curl -H "X-Rundeck-Auth-Token:$TOKEN" -o $CURL_OUT -H "Accept: application/xml" -X GET "$URL" >/dev/null 2>&1 

CONT=0
for JOB in $(xmlstarlet sel -t -m "//job" -m "@id" -v . -n ${CURL_OUT})
do
	URL="http://${NODE}:4440/api/23/job/${JOB}/run"
	curl -H "X-Rundeck-Auth-Token:$TOKEN" -o $CURL_OUT -X POST "$URL" >/dev/null 2>&1
	
	for ID in $(xmlstarlet sel -t -m "//job/name" -v . -n ${CURL_OUT})
	do
		echo "Executando job: $ID"
		CONT=$((CONT+1))
	done	
done
echo "Total de Jobs do projeto $PROJECT, executados: $CONT"
