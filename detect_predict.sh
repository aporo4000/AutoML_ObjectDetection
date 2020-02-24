#!/bin/sh


echo $1  
echo $2  # resources/request.json  # output predict json
 
model_id=`cat $1/detect_progress_train_$PROJECT_ID.json`  

curl -X POST -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" -H "Content-Type: application/json" "https://automl.googleapis.com/v1beta1/projects/${PROJECT_ID}/locations/us-central1/models/$model_id:predict" -d @$2 > $1/detect_predict_output.txt
