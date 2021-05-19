#!/bin/bash 
apt update
apt-get install openjdk-11-jdk -y
apt install awscli -y
mkdir /home/ubuntu/target
while true; do
  status_bucket=`aws s3 ls s3://${s3_bucket}/`
  if [ "$status_bucket" != "" ]; then
    echo "Trying to download"
      break
    fi
  sleep 5
  echo "Still checking."
done
aws s3 sync s3://${s3_bucket}/ /home/ubuntu/target  --exclude "*" --include *.jar
java -jar /home/ubuntu/target/*.jar &
