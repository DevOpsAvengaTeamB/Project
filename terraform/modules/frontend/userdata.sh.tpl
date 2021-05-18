#!/bin/bash 
apt update
apt install nginx -y
apt install awscli -y
rm -rf /usr/share/nginx/html/*
rm -rf /etc/nginx/sites-enabled/*
sleep 600
aws s3 --recursive  cp s3://${aws_s3_bucket}/shop/ /usr/share/nginx/html/
chmod 777 -R /usr/share/nginx/html/*
aws s3 cp s3://${aws_s3_bucket}/default.conf /etc/nginx/conf.d/
chmod 777 /etc/nginx/conf.d/*
systemctl restart nginx.service 
