# -*- coding: utf-8 -*-
#!/usr/bin/env python
import os
import json
import argparse
from google.cloud import automl_v1beta1 as automl



def undeploy_model(project_id, model_id):
    """Undeploy a model."""
    # [START automl_vision_object_detection_undeploy_model]
    from google.cloud import automl_v1beta1 as automl

    # project_id = 'YOUR_PROJECT_ID'
    # model_name = 'YOUR_MODEL_ID'

    client = automl.AutoMlClient()

    # The full path to your model
    full_model_id = client.model_path(project_id, 'us-central1', model_id)

    # Undeploy the model
    response = client.undeploy_model(full_model_id)

    print(u'Model undeploy finished'.format(response.result()))
    # [END automl_vision_object_detection_undeploy_model]


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument("-u") # 位置引数fooを定義
    args = p.parse_args()   # デフォルトでsys.argvを解析
    print(args.u)  
    
    model_path = args.u+'/'+'detect_progress_train_'+os.environ['PROJECT_ID']+'.json'
    with open(model_path, 'r') as f:
        model_id = f.read()
    print("model_id :", model_id)
    project_id = os.environ['PROJECT_ID']
    print("project_id :", project_id)

    undeploy_model(project_id, model_id)
