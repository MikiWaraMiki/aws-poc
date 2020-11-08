# AWS 検証用

AWS を試し程度に、色々といじるリポジトリ

---

## Dir Kinesis

### 概要

CloudWatch のログを Kinesis 経由で S3 に保存する仕組み検証

### 必要なツール

- terraform(>=0.13.4)
- aws account

### 準備

- terraform ディレクトリ配下に、config.tfvars と kinesis.tfbackend ファイルを作成する

config.tfvars

```
region        = "ap-northeast-1"
profile       = "AWSアカウントのプロファイル"
key_file_path = "EC2で利用する、SSH公開鍵のパス"
```

kinesis.tfbackend

```
bucket="tfstateを保存するS3のバケット名"
key="バケット内のprefix"
region="S3のリージョン"
```

### 作成

```
make init ARG="profile=AWSアカウントのプロファイル名"
make plan
make apply
```

### 削除

```
make destroy
```
