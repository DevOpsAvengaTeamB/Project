#!/usr/bin/env bashapt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade
apt-get install openjdk-8-jre -y
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch |  apt-key add -
apt-get update
apt-get install apt-transport-https -y
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" |  tee -a /etc/apt/sources.list.d/elastic-7.x.listapt-get update -y
apt-get install elasticsearch kibana nfs-common -y# Mount EFSmkdir -p /efs
efs_host="${efs_name}"
mount  -t nfs4 $efs_host:/ /efs
# Edit fstab so EFS to enable reboot
echo $efs_host:/ /efs nfs defaults,_netdev 0 0 >> /etc/fstabsystemctl stop elasticsearch# use --batch mode for non-interactive installation/usr/share/elasticsearch/bin/elasticsearch-plugin install repository-s3 --batch
cat << EOF >>/etc/elasticsearch/elasticsearch.yml
network.host : 0.0.0.0
discovery.type: single-node
EOFrm -fr /var/lib/elasticsearch
mkdir -p /efs/elasticsearchln -s /efs/elasticsearch /var/lib/elasticsearch
chown -R elasticsearch:elasticsearch /efs/elasticsearchsystemctl start  elasticsearch
systemctl enable elasticsearch
systemctl enable kibana
# wait for elasticsearch restart
sleep 30# Configure s3 repository snapshotcurl -X PUT "localhost:9200/_snapshot/my_s3_repository?pretty" -H 'Content-Type: application/json' -d'
{
"type": "s3",
"settings": {
"bucket": "${s3_backup_bucket}"
}
}
'#echo "server.host: \"0.0.0.0\"" >> /etc/kibana/kibana.yml
systemctl restart kibana
systemctl enable kibana
apt-get install nginx apache2-utils  -ycat << EOF >/etc/nginx/htpasswd.users
kibanaadmin:\$apr1\$g7YCou3m\$0fRATc3.59bF9Tr1sVVza.
EOFcat << EOF > /etc/cron.daily/elastic
#!/bin/bash
DAY=\$(date +%d)
curl -X DELETE "localhost:9200/_snapshot/my_s3_repository/snapshot_\$${DAY}?pretty"
curl -X PUT "localhost:9200/_snapshot/my_s3_repository/snapshot_\$${DAY}?wait_for_completion=true&pretty"
EOFchmod 755 /etc/cron.daily/elastic
rm -f /etc/nginx/sites-enabled/default
cat << EOF >/etc/nginx/sites-enabled/kibanaserver {listen 80;server_name logs.iy.deeploy.app;
auth_basic “Kibana”;
auth_basic_user_file  /etc/nginx/htpasswd.users;
error_log   /var/log/nginx/kibana.error.log;
access_log  /var/log/nginx/kibana.access.log;
location / {rewrite ^/(.*) /\$1 break;
proxy_ignore_client_abort on;
proxy_pass http://127.0.0.1:5601;
proxy_set_header  X-Real-IP  \$remote_addr;
proxy_set_header  X-Forwarded-For \$proxy_add_x_forwarded_for;
proxy_set_header  Host \$http_host;}}EOFsystemctl restart nginxsystemctl enable nginx

