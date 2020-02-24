# -*- coding: utf-8 -*-
#!/usr/bin/env python

import os
import json
import argparse


p = argparse.ArgumentParser()
p.add_argument("-u") # 位置引数fooを定義
args = p.parse_args()   # デフォルトでsys.argvを解析
print(args.u)

with open(args.u+"/detect_train_output.txt", "r") as f:
    output = f.read()


replace_output = output.split(',')[0].split(':')[-1].split('/')[-1].replace('"', '').replace("'", "")
with open(args.u+"/detect_train_output.txt", "w") as f:
    f.write(replace_output)


