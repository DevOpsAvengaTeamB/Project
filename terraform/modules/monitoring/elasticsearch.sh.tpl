#//bin/bash
apt-get install apt-transport-https -y
apt install -y openjdk-11-jdk


# Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.12.1-amd64.deb
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.12.1-amd64.deb.sha512
shasum -a 512 -c elasticsearch-7.12.1-amd64.deb.sha512 
dpkg -i elasticsearch-7.12.1-amd64.deb 


# Filebeat 

wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.12.1-amd64.deb
dpkg -i filebeat-7.12.1-amd64.deb



# elasticsearch.yml

sed -i '
s/#http.port: 9200/http.port: 9200/;
s/#network.host: 192.168.0.1/network.host: 0.0.0.0/' /etc/elasticsearch/elasticsearch.yml

systemctl enable elasticsearch.service
systemctl start elasticsearch.service


# apt-get update && apt-get install kibana

wget https://artifacts.elastic.co/downloads/kibana/kibana-7.12.1-amd64.deb
shasum -a 512 kibana-7.12.1-amd64.deb 
sudo dpkg -i kibana-7.12.1-amd64.deb


sed -i '
s/#server.port: 5601/server.port: 5601/;
s/#server.host: "localhost"/server.host: 0.0.0.0/;
s/#elasticsearch.hosts: ["http:\/\/localhost:9200"]/elasticsearch.hosts: ["http:\/\/localhost:9200"]/;
s/#pid.file: \/run\/kibana\/kibana.pid/pid.file: \/run\/kibana\/kibana.pid/' /etc/kibana/kibana.yml

echo 'server.basePath: "/kibana"' >> /etc/kibana/kibana.yml

systemctl daemon-reload
systemctl enable kibana.service
systemctl start kibana.service


systemctl enable filebeat.service
systemctl start filebeat

