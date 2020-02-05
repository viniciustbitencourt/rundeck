#!/bin/bash

RETENTION=$1
TOKEN=$2
NODE=$3

if [ "$#" -ne 3 ];then
	echo "Falha na execução do Script, favor checar os parametros e reiniciar a execucão"
	exit 1
else

	echo "Executando o Script, Periodo de Retencao: ${RETENTION}"
	date

CURL_OUT=/tmp/curl.out.$$

URL="http://${NODE}:4440/api/23/projects"

#URL="http://${NODE}:4440/api/24/project/Manutencao"
curl -H "X-Rundeck-Auth-Token:$TOKEN" -H "Content-Type: application/xml" -X GET "$URL"  2>/dev/null  > $CURL_OUT

projects=`xmlstarlet sel -t -m "//project/name" -v . -n $CURL_OUT`

purged=0
for PROJECT in $projects
do
   URL="http://${NODE}:4440/api/23/project/${PROJECT}/jobs"
   curl -H "X-Rundeck-Auth-Token:$TOKEN" -o $CURL_OUT -H "Accept: application/xml" -X GET "$URL" >/dev/null  2>&1

   for JOB in $(xmlstarlet sel -t -m "/jobs/job" -m "@id" -v . -n ${CURL_OUT})
   do
	# Para cada job, pega a ultima execucao
	URL="http://${NODE}:4440/api/23/job/${JOB}/executions?offset=${RETENTION}"
	curl -H "X-Rundeck-Auth-Token:$TOKEN" -o $CURL_OUT -H "Accept: application/xml" -X GET "$URL" >/dev/null 2>&1
	for ID in $(xmlstarlet sel -t -m "/executions/execution" -m "@id" -v . -n ${CURL_OUT})
	do
		URL="http://${NODE}:4440/api/24/executions/delete?ids=${ID}"

		echo "Deletando execucao job $URL"

		#echo curl -H "X-Rundeck-Auth-Token:$TOKEN" -X POST "$URL"  2>&1
		curl -H "X-Rundeck-Auth-Token:$TOKEN"  -X POST "$URL"  2>&1

		purged=$((purged+1))
	done
   done
done
echo "Execucoes de jobs deletados: $purged"
fi
exit 0
