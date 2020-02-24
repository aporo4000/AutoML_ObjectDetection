#!/bin/sh


echo $1  # saitama_DT_001
echo $2  # model_DT_001
 
dataset_id=`cat $1/detect_create_output.txt`

### curl -X POST -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" -H "Content-Type: application/json" https://automl.googleapis.com/v1beta1/projects/${PROJECT_ID}/locations/us-central1/models -d '{  "datasetId": "IOD5381471701219409920",  "displayName": "dataset01",  "image_object_detection_model_metadata": {"train_budget": 1},}' > $1/detect_train_output.txt

# ユーザーフォルダ名, モデル名, データセットID
python detect_train.py create_model -u $1 --model_name $2 $dataset_id

python output_train_replace.py -u $1 
