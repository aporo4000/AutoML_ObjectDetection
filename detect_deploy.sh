#!/bin/sh


echo $1  

model_id=`cat $1/detect_progress_train_$PROJECT_ID.json`

echo $model_id

curl -X POST -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" -H "Content-Type: application/json" https://automl.googleapis.com/v1beta1/projects/${PROJECT_ID}/locations/us-central1/models/$model_id:deploy -d '{ "imageObjectDetectionModelDeploymentMetadata": { "nodeCount": 1 }}' > $1/detect_deploy_output.txt

python output_deploy_replace.py -u $1 
