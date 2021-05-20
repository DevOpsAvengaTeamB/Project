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

adduser --no-create-home --disabled-login --shell /bin/false --gecos "Node Exporter User" node_exporter

#download node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
tar -xzvf node_exporter-1.1.2.linux-amd64.tar.gz
mv node_exporter-1.1.2.linux-amd64.tar.gz/node_exporter /usr/local/bin
rm node_exporter-1.1.2.linux-amd64.tar.gz
chown -R prometheus:prometheus /home/prometheus/node_exporter

# Filebeat 
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.12.1-amd64.deb
dpkg -i filebeat-7.12.1-amd64.deb

#Add node_exporter as system service
echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
[Install]
WantedBy=multi-user.target" | tee /etc/systemd/system/node_exporter.service

systemctl daemon-reload
systemctl start node_exporter
system enable node_exporter

systemctl enable filebeat.service
systemctl start filebeat
