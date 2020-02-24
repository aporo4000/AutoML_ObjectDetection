# -*- coding: utf-8 -*-
#!/usr/bin/env python

import os
import json
import argparse


p = argparse.ArgumentParser()
p.add_argument("-u") # 位置引数fooを定義
args = p.parse_args()   # デフォルトでsys.argvを解析
print(args.u)

file_path = args.u+'/'+'detect_progress_train_'+os.environ['PROJECT_ID']+'.json'




def replace_text(file_path):
    try:
        with open(file_path, 'r') as f:
            res = json.load(f)
            # model_id = res["response"]["name"].split('/')[-1]
            complete = res["done"]
            if complete is True:
                model_id = res["response"]["name"].split('/')[-1]

        with open(file_path, 'w') as f:
            f.write(model_id)
        print("complete True")
    except KeyError:
        print("Please wait while learning ...")
 

with open(file_path, 'r') as f:
    if len(f.readlines()) > 8:
        replace_text(file_path)
    else:
        print("Please wait while learning ...")
 
