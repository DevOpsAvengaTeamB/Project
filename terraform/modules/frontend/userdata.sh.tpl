#!/bin/bash 
apt update
apt install nginx -y
apt install awscli -y
touch ggggg
aws s3 cp ggggg s3://${aws_s3_bucket}/
