#!/bin/bash 
echo ${elastic_ip}
echo ${prometheus_ip}
apt update
apt install nginx -y
apt install awscli -y
while true; do
  status_bucket=`aws s3 ls s3://${aws_s3_bucket}/`
  if [ "$status_bucket" != "" ]; then
    echo "Trying to download"
      break
    fi
  sleep 5
  echo "Still checking."
done
rm -rf /usr/share/nginx/html/*
rm -rf /etc/nginx/sites-enabled/*
aws s3 --recursive  cp s3://${aws_s3_bucket}/shop/ /usr/share/nginx/html/
chmod 777 -R /usr/share/nginx/html/*
aws s3 cp s3://${aws_s3_bucket}/default.conf /etc/nginx/conf.d/
chmod 777 /etc/nginx/conf.d/*
systemctl restart nginx.service 
