#!bin/bash
apt-get install apt-transport-https
apt install openjdk-8-jdk

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.8.15-amd64.deb
sudo dpkg -i filebeat-6.8.15-amd64.deb

# filebeat.yml 

sed -i 's/#filebeat.modules:/filebeat.modules:/g' /etc/filebeat/filebeat.yml
sed -i 's/#- module: elasticsearch/- module: elasticsearch/g' /etc/filebeat/filebeat.yml
sed -i 's/#server:/server: enabled: true/g' /etc/filebeat/filebeat.yml
sed -i 's/#audit:/audit: enabled: true/g' /etc/filebeat/filebeat.yml
sed -i 's/#- module: kibana/- module: kibana/g' /etc/filebeat/filebeat.yml
sed -i 's/#log:/log: enabled: true/g' /etc/filebeat/filebeat.yml
sed -i 's/#audit:/audit: enabled: true/g' /etc/filebeat/filebeat.yml
sed -i 's/#-type: log/-type: log/g' /etc/filebeat/filebeat.yml
sed -i 's/#enabled: true/enabled: true/g' /etc/filebeat/filebeat.yml
sed -i 's/#paths: - /var/log/*.log/paths: - /var/log/*.log/g' /etc/filebeat/filebeat.yml
sed -i 's/#output.elasticsearch:/output.elasticsearch:/g' /etc/filebeat/filebeat.yml
sed -i 's/#enabled: true/enabled: true/g' /etc/filebeat/filebeat.yml
sed -i 's/#setup.dashboards.enabled: true/setup.dashboards.enabled: true/g' /etc/filebeat/filebeat.yml

# echo "filebeat.modules:
#        - module: elasticsearch
#         server: 
#          enabled: true
#         audit:
#          enabled: true
#       - module: kibana
#         log: 
#          enabled: true
#         audit:
#          enabled: true
#       filebeat.inputs:
#        -type: log
#        enabled: true
#        paths:
#         - /var/log/*.log
#       output.elasticsearch: 
#        enabled: true
#       setup.dashboards.enabled: true" | tee /etc/filebeat/filebeat.yml

filebeat modules list
filebeat modules enable system nginx mysql
systemctl enable filebeat
systemctl start filebeat