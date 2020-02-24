#!/bin/sh

DATA=`cat $1/detect_deploy_output.txt`

HEAD=`echo Authorization: Bearer $(gcloud auth application-default print-access-token)`
HEAD1='Content-Type: application/json'
URL="https://automl.googleapis.com/v1beta1/projects/${PROJECT_ID}/locations/us-central1/operations/"

while read line
do
    echo $line
    curl -X GET -H "$HEAD" -H "$HEAD1" $URL$line > $1/detect_progress_deploy_$PROJECT_ID.json


done << FILE
$DATA
FILE

python output_progress_deploy_replace.py -u $1
