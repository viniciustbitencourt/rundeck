#!/bin/bash
PROJECT_NAME="$1"
JOB_ID="$2"
JOB_STATUS=$3
TOKEN="$4"
TESTE="$5"

curl -s "http://rundeck-prd001.net/api/1/job/${JOB_ID}?project=${PROJECT_NAME}&authtoken=${TOKEN}&format=xml"  -o "/dev/shm/${JOB_ID}"  -v
	 
UPDATE=$(egrep -c "scheduleEnabled" /dev/shm/${JOB_ID} )
if [  $UPDATE -eq 1 ]
then
  xmlstarlet ed -L  -u   "/joblist/job/scheduleEnabled"   -v "${JOB_STATUS}"  "/dev/shm/${JOB_ID}" 
else
   xmlstarlet ed -L  -i   "/joblist/job/scheduleEnabled" -t elem  -n scheduleEnabled  -v ${JOB_STATUS} "/dev/shm/${JOB_ID}" 
fi
#echo ${XML_JOB}
curl -s "http://rundeck-prd001.net/api/14/jobs/import?project=${PROJECT_NAME}&authtoken=${TOKEN}&dupeOption=update&uuidOption=remove"  -d "xmlBatch=$(cat /dev/shm/${JOB_ID})"   -v -d "Content-Type: x-www-form-urlencoded"
	  
