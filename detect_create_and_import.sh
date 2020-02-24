#!/bin/sh

if [ ! -e $1 ]; then
    mkdir $1
fi

echo $1 
echo $2 
command0="pip install google-cloud-automl" 
# command1="gcloud auth login"
command2="gcloud config set project $PROJECT_ID"  
#command3="gcloud projects add-iam-policy-binding $PROJECT_ID --member='user:$USER_DOMAIN' --role='roles/automl.admin'"
command4="gcloud projects add-iam-policy-binding $PROJECT_ID --member='serviceAccount:$SERVICE_ACCOUNT' --role='roles/automl.editor'"

python detect_create_and_import.py create_dataset -u $1 $2

# 実行
eval $command0
# eval $command1
eval $command2
eval $command3 
eval $command4 

command5="gsutil mb -p $PROJECT_ID -c regional -l $REGION_NAME gs://$PROJECT_ID-vcm/"

# 実行
eval $command5

if [ -e ../img/$1/temp ]; then
    rm -rf ../img/$1/temp
fi

mkdir -p ../img/$1/temp/$1

for file in `ls ../img/$1 | grep [0-9]`; do
  cp -rf ../img/$1/${file} ../img/$1/temp/$1/
done

if [ -e ../img/$1/ext ]; then
    cp -rf ../img/$1/ext ../img/$1/temp/$1/
fi

if [ -e ../img/$1/salads_ml_use.csv ]; then
    cp -rf ../img/$1/salads_ml_use.csv ../img/$1/temp/$1/
fi

command6="gsutil -m cp -R ../img/$1/temp/$1  gs://$PROJECT_ID-vcm/img/"

eval $command6

### 
DATA=`cat $1/detect_create_output.txt`

while read line
do


echo $line
# user_folder, dataset_id, import_path
python detect_create_and_import.py import_data -u $1 --path "gs://$PROJECT_ID-vcm/img/$1/salads_ml_use.csv" $line

done << FILE
$DATA
FILE

