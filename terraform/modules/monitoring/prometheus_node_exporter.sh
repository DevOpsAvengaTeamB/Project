#!/bin/bash
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
