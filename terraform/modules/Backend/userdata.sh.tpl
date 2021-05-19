#!/bin/bash 
apt-get install openjdk-11-jdk -y
apt install awscli -y
mkdir /home/ubuntu/target
aws s3 sync s3://${s3_bucket}/ /home/ubuntu/target  --exclude "*" --include *.jar
java -jar /home/ubuntu/target/*.jar &
