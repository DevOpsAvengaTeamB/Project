#//bin/bash
apt-get install apt-transport-https -y
apt install -y openjdk-11-jdk
#apt install -y nginx
#service nginx restart

# Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.12.1-amd64.deb
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.12.1-amd64.deb.sha512
shasum -a 512 -c elasticsearch-7.12.1-amd64.deb.sha512 
dpkg -i elasticsearch-7.12.1-amd64.deb 

update-rc.d elasticsearch defaults 95 10
# systemctl daemon-reload
# jornalctl -f
# journalctl -unit elasticsearch

# Filebeat 

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.12.1-amd64.deb
dpkg -i filebeat-7.12.1-amd64.deb

# filebeat modules list
# filebeat modules enable system nginx mysql


# Metricbeat
# curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.12.1-amd64.deb
# dpkg -i metricbeat-7.12.1-amd64.deb

# metricbeat modules enable system
# metricbeat setup -e
# systemctl start metricbeat

# elasticsearch.yml
# sed -i 's/#network.host.*/network.host: localhost/g' /etc/alesticsearch/elasticsearch.yml
# sed -i 's/#transport.tcp.port.*/transport.tcp.port: 9300/g' /etc/alesticsearch/elasticsearch.yml
# sed -i 's/#http.port.*/http.port: 9200/g' /etc/alesticsearch/elasticsearch.yml
# sed -i 's/#network.host.*/network.host: 0.0.0.0/g' /etc/alesticsearch/elasticsearch.yml

#cd /etc/elasticsearch/

sed -i '
s/#http.port: 9200/http.port: 9200/;
s/#network.host: 192.168.0.1/network.host: 127.0.0.1/' /etc/elasticsearch/elasticsearch.yml

systemctl enable elasticsearch.service
systemctl start elasticsearch.service

# filebeat.yml 
# sed -i 's/#filebeat.modules:/filebeat.modules:/g' /etc/filebeat/filebeat.yml
# sed -i 's/#- module: elasticsearch/- module: elasticsearch/g' /etc/filebeat/filebeat.yml
# sed -i 's/#server:/server: enabled: true/g' /etc/filebeat/filebeat.yml
# sed -i 's/#audit:/audit: enabled: true/g' /etc/filebeat/filebeat.yml
# sed -i 's/#- module: kibana/- module: kibana/g' /etc/filebeat/filebeat.yml
# sed -i 's/#log:/log: enabled: true/g' /etc/filebeat/filebeat.yml
# sed -i 's/#audit:/audit: enabled: true/g' /etc/filebeat/filebeat.yml
# sed -i 's/#-type: log/-type: log/g' /etc/filebeat/filebeat.yml
# sed -i 's/#enabled: true/enabled: true/g' /etc/filebeat/filebeat.yml
# sed -i 's/#paths: - /var/log/*.log/paths: - /var/log/*.log/g' /etc/filebeat/filebeat.yml
# sed -i 's/#output.elasticsearch:/output.elasticsearch:/g' /etc/filebeat/filebeat.yml
# sed -i 's/#enabled: true/enabled: true/g' /etc/filebeat/filebeat.yml
# sed -i 's/#setup.dashboards.enabled: true/setup.dashboards.enabled: true/g' /etc/filebeat/filebeat.yml

sed -i '
s/#filebeat.inputs:/filebeat.inputs:/;
s/#- type: log/- type: log/;
s/#enabled: false/enabled: true/;
s/#path:/path/;
s/#- \/var\/log\/*.log/#- \/var\/log\/*.log/;
s/#filebeat.modules:/filebeat.modules:/;
s/#- module: system/- module: system/;
s/#syslog:/syslog:/;
s/#enabled: true/enabled: true/;
s/#- module: auditd/- module: auditd/;
s/#log:/log:/;
s/#enabled: true/enabled: true/;
s/#setup.dashboards.enabled: false/setup.dashboards.enabled: true/;
s/#setup.kibana/setup.kibana/;
s/#output.elasticsearch:/output.elasticsearch:/; 
s/#hosts: ["localhost:9200"]/hosts: ["elasticsearch:9200"]/' /etc/filebeat/filebeat.yml

${instance_monitoring_private_ip}, ${instance_logging_private_ip}

systemctl enable filebeat.service
systemctl start filebeat

# apt-get update && apt-get install kibana

wget https://artifacts.elastic.co/downloads/kibana/kibana-7.12.1-amd64.deb
shasum -a 512 kibana-7.12.1-amd64.deb 
sudo dpkg -i kibana-7.12.1-amd64.deb

# kibana.yml
sed -e '
s/#server.port: 5601/server.port: 5601/;
s/#server.host: "localhost"/server.host: 0.0.0.0/;
s/#server.name:/server.name: kibana/;
s/#monitoring.ui.enabled: false/monitoring.ui.enabled: true/;
s/#elasticsearch.hosts: ["http:\/\/localhost:9200"]/elasticsearch.hosts: [${instance_logging_private_ip}, ${instance_monitoring_private_ip}, ]' /etc/kibana/kibana.yml

/bin/systemctl daemon-reload
/bin/systemctl enable kibana.service
systemctl start kibana.service