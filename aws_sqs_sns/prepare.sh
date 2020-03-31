#!/bin/bash

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip";
unzip awscliv2.zip;
./aws/install;
ln -s /usr/local/bin/aws /usr/bin/aws;

mkdir ~/.aws/;

echo "[default]
output = json
region = us-east-1" > ~/.aws/config;
   
echo "[default]
aws_secret_access_key = x
aws_access_key_id = x" > ~/.aws/credentials;