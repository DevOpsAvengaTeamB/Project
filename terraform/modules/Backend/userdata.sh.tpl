#!/bin/bash 
apt-get install openjdk-11-jdk -y
apt install awscli -y
aws s3 --recursive  cp s3://${s3_bucket}/target/ target/
chmod 444 -R /tmp/target/*
