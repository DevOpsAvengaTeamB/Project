#!/bin/bash

# Prometheus installation. It's a lousy script though.

adduser --no-create-home --disabled-login --shell /bin/false --gecos "Prometheus Monitoring User" prometheus
adduser --no-create-home --disabled-login --shell /bin/false --gecos "Node Exporter User" node_exporter
adduser --no-create-home --disabled-login --shell /bin/false --gecos "Alertmanager User" alertmanager

mkdir /etc/prometheus
mkdir /etc/alertmanager
mkdir /etc/alertmanager/template


# Use /var/lib/<package_name> to store app data

mkdir /var/lib/prometheus
mkdir -p /var/lib/alertmanager/data

touch /etc/prometheus/prometheus.yml
touch /etc/alertmanager/alertmanager.yml

chown -R prometheus:prometheus /etc/prometheus
chown -R alertmanager:alertmanager /etc/alertmanager
chown prometheus:prometheus /var/lib/prometheus
chown -R alertmanager:alertmanager /var/lib/alertmanager

wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz
wget https://github.com/prometheus/alertmanager/releases/download/v0.12.0/alertmanager-0.21.0.linux-amd64.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
wget https://dl.grafana.com/oss/release/grafana_7.5.5_amd64.deb

tar xvzf prometheus-2.26.0.linux-amd64.tar.gz
tar xvzf alertmanager-0.21.0.linux-amd64.tar.gz
tar xvzf node_exporter-1.1.2.linux-amd64.tar.gz

cp prometheus-2.26.0.linux-amd64/prometheus /usr/local/bin/
cp prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
cp -r prometheus-2.26.0.linux-amd64/consoles /etc/prometheus
cp -r prometheus-2.26.0.linux-amd64/console_libraries /etc/prometheus
cp alertmanager-0.21.0.linux-amd64/alertmanager /usr/local/bin/
cp alertmanager-0.21.0.linux-amd64/amtool /usr/local/bin/
cp node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin/

chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
chown alertmanager:alertmanager /usr/local/bin/alertmanager
chown alertmanager:alertmanager /usr/local/bin/amtool
chown node_exporter:node_exporter /usr/local/bin/node_exporter

# prometheus.yml

echo "global:
  scrape_interval: 1s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 1s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node'
    scrape_interval: 1s
    static_configs:
      - targets: ['localhost:9100']" |    tee /etc/prometheus/prometheus.yml


# alertmanager.yml

echo "global:
  smtp_smarthost: 'localhost:25'
  smtp_from: 'alertmanager@example.org'
  smtp_auth_username: 'alertmanager'
  smtp_auth_password: 'password'
templates:
- '/etc/alertmanager/template/*.tmpl'
route:
  repeat_interval: 3h
  receiver: team-X-mails
receivers:
- name: 'team-X-mails'
  email_configs:
  - to: 'team-X+alerts@example.org'" |    tee /etc/alertmanager/alertmanager.yml

# prometheus.service

echo "[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries
[Install]
WantedBy=multi-user.target" |    tee /etc/systemd/system/prometheus.service

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

# node_exporter.service

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
WantedBy=multi-user.target" |    tee /etc/systemd/system/node_exporter.service

systemctl daemon-reload
systemctl enable node_exporter
systemctl start node_exporter

# alertmanager.service

echo "[Unit]
Description=Prometheus Alert Manager service
Wants=network-online.target
After=network.target
[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager \
    --config.file /etc/alertmanager/alertmanager.yml \
    --storage.path /var/lib/alertmanager/data
Restart=always
[Install]
WantedBy=multi-user.target" |    tee /etc/systemd/system/alertmanager.service

systemctl daemon-reload
systemctl enable alertmanager
systemctl start alertmanager

# grafana installation

apt-get install -y adduser libfontconfig
dpkg -i grafana_7.5.5_amd64.deb

/bin/systemctl daemon-reload
/bin/systemctl enable grafana-server
/bin/systemctl start grafana-server

# cleanup

rm prometheus-2.26.0.linux-amd64.tar.gz
rm alertmanager-0.21.0.linux-amd64.tar.gz
rm node_exporter-1.1.2.linux-amd64.tar.gz
rm grafana_7.5.5_amd64.deb

rm -rf prometheus-2.26.0.linux-amd64
rm -rf alertmanager-0.21.0.linux-amd64
rm -rf node_exporter-1.1.2.linux-amd64