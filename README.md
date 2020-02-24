# 設定  
参考URL(チュートリアル) : https://cloud.google.com/vision/automl/object-detection/docs/quickstart?hl=ja  
参考URL(上限値確認) : https://cloud.google.com/vision/automl/object-detection/docs/prepare?hl=ja  
参考URL(学習モデル作成時の詳細設定) : https://cloud.google.com/vision/automl/object-detection/docs/reference/rest/v1beta1/projects.locations.models?hl=JA#resource-model  
(こちらに小文字記法で紹介：https://googleapis.dev/python/automl/0.6.0/_modules/google/cloud/automl_v1beta1/tables/tables_client.html)   

# 設定情報は小文字の_記法でないとエラーになる  
例：{  
  "modelType": string,   → "model_type"  
  "nodeCount": string,   → "node_count"    
  "nodeQps": number,     → "node_qps"   
  "stopReason": string,  → "stop_reason"  
  "trainBudgetMilliNodeHours": string,  → "train_budget_milli_node_hours"  
  "trainCostMilliNodeHours": string,    → "train_cost_milli_node_hours"  
  "disableEarlyStopping": boolean       → "disable_early_stopping"  
}  
実例：my_model = {  
         'display_name': model_name,  
         'dataset_id': dataset_id,  
         'image_object_detection_model_metadata': {  
             "node_count": 1,  
             "train_budget_milli_node_hours": 20000, # 1ノード時間 = 1000(最低設定値: 20000)  
             "train_cost_milli_node_hours": 1000   # 1ノード時間 = 1000  
         }  
      }  


# 入力データの詳細な決まりごと  
 - トレーニングラベル：最小でも10BOX & 10画像必要  
   (100枚が望ましい結果となる)  
 - アノテーションBOX最小サイズ: 8pixel x 8pixel  
                                画像サイズ100pixel x 90pixelなら 10pixel x 9pixelまで  
   1画像に対してアノテーションBOX最大数：500個まで  
   params.max_bounding_box_count field  設定値変更可能  
 - ラベル数(クラス数)：最小1個、最大1000個  
   画像数：最大150,000枚  
   アノテーション数：最大1,000,000個  



1. Google cloud SDKをサーバーへインストール  
参考サイト：https://cloud.google.com/sdk/install  
(python2.7系が利用可能な環境にしておく）  

2. linux jq コマンドのインストール  
参考サイト：https://qiita.com/wnoguchi/items/70a808a68e60651224a4  

3. Google Cloud Platformコンソール  
 - プロジェクトを作成  
 - (MENU) 作成したプロジェクトへ移動  
 - (MENU) APIとサービス  
          - APIライブラリ  
            - Cloud AutoML APIを有効にする  
 - (MENU) APIとサービス  
          - APIライブラリ  
            - 認証情報  
              → サービスアカウントキーをダウンロード  
 - (MENU) ホーム  
          → プロジェクト情報＞プロジェクトID　メモ  
 - (MENU) IAMと管理  
          - サービスアカウント  
              → メール部分"サービスアカウント名"をメモ  

# 環境  
1. 運用サーバーへの環境変数登録  
 - サービスアカウントキー.jsonを任意の場所へ  
 - 環境変数へ登録(.bashrcなど)  
   # GOOGLE CLOUD PLATFORM  
   export GOOGLE_APPLICATION_CREDENTIALS=任意の場所/サービスアカウントキー.json  
   export PROJECT_ID="プロジェクトID"  
   export REGION_NAME="us-central1"  ← このリージョン名は固定  
   export SERVICE_ACCOUNT="サービスアカウント名"  
                          (例:●●●@●●●@iam.gserviceaccount.com)  
 - パス通す(以下実行)  
   $ source .bashrc     

 - パス確認  
   $ echo $環境変数 (例 echo $SERVICE_ACCOUNT)  
     ちゃんと出力されるとOK  

2. 必要フォルダ作成  
 - automl_vision_dataset.pyファイルがある同階層に  
   各ユーザー名＋一意の値  << sample_DTフォルダ名を作成しています。  

3. 必要ライブラリのインポート  
   $ sudo pip install google-cloud-automl  

4. コマンドラインで以下の入力しプロジェクトへ権限付与  
   $ gcloud auth login  
   $ gcloud config set project $PROJECT_ID  
   $ gcloud projects add-iam-policy-binding $PROJECT_ID \  
   --member="serviceAccount:custom-vision@appspot.gserviceaccount.com" \  
   --role="roles/ml.admin"  
   $ gcloud projects add-iam-policy-binding $PROJECT_ID \  
   --member="serviceAccount:custom-vision@appspot.gserviceaccount.com" \  
   --role="roles/storage.admin"  

5. プロジェクトへバケットを用意する  
   $ gsutil mb -p $PROJECT_ID -c regional -l $REGION_NAME gs://$PROJECT_ID-vcm/     


# Object Detection 編  
### 準備  
1. 入力画像の準備  
   img/sample_DT/*  (ここに全て配置)  


2. アノテーションファイル準備  
   img/*  



### 使い方  
1. データセット作成＆＆インポート  
  $ bash detect_create_and_import.sh sample_DT dataset_DT_001  
    sample_DT/detect_create_output.txt  にデータセットIDが出力される  


2. インポート進捗確認  
  $ ユーザーフォルダ名/detect_import_output.txt ファイル作成されていればOK  
  完了して入れば「Data imported.」記入される  

3. 学習  
  $ bash detect_train.sh sample_DT model_DT_001  
   (エラーの際のチェックポイント)  
    - csvのプロジェクト名/ユーザーフォルダ名/ どちらか間違えていないか？  
    - 学習用画像は1クラスに対して10BOX作られているか？  
    - csvのTRAINに対して最低TRAIN:TEST:VALIDATE -> 8:1:1用意されているか？  




4. 学習進捗確認(ここは必ず実行してファイルを出力)  
   $ bash detect_progress_train.sh sample_DT  
     (学習中)   
       Please wait while learning ...  
       
     (学習完了)  
       complete True  
       sample_DT/detect_progress_train_$PROJECT_ID.json にモデルIDが出力される  


5. デプロイ  
   $ bash detect_deploy.sh sample_DT  
     sample_DT/detect_deploy_output.txt  へオペレーションIDが出力される  
     デプロイノード数(クラスタの箱用意がデプロイでノードがインスタンスのイメージ)  
     は、1ノードは最低建てないといけないみたい。(インスタンス建てる == 課金開始)  

6. デプロイ進捗確認  
   $ bash detect_progress_deploy.sh sample_DT  
      (デプロイ中)   
       Please wait while learning ...  
       sample_DT/detect_progress_deploy_sample-project-1-255401.json  進捗表示  
       
     　(学習完了)  
       complete True  
       sample_DT/detect_progress_deploy_sample-project-1-255401.json オペレーションIDのみ残す(特に意味はない)  
 
     
7. 推論  
   $ bash detect_predict.sh sample_DT resources/request.json  
     sample_DT/detect_predict_output.txt  
        例：   
          {  
          "payload": [  
            {  
              "annotationSpecId": "3869458495073943552",  
              "imageObjectDetection": {  
                "boundingBox": {  
                  "normalizedVertices": [  
                    {  
                      "x": 0.320895,   << xmin  
                      "y": 0.098934    << ymin  
                    },  
                    {  
                      "x": 0.660415,   << xmax  
                      "y": 0.283989    << ymax  
                    }  
                  ]  
                },  
                "score": 0.980167      << スコア  
              },  
              "displayName": "Tomato"  << 予測ラベル名  
            },  


# 推論完了後すぐにアンデプロイ実行しないと課金が続く(ノードを立てているだけ課金)  
8. アンデプロイ  
   $ bash detect_undeploy.sh sample_DT  

検索方法  
 dataset検索  
 $ python automl_vision_dataset.py list_datasets ''  
 dataset一覧が出力  

 model検索  
 $ python automl_vision_model.py list_models ''  
 model一覧が出力  
   deploy情報も出力されている  
