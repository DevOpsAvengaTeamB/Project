#!/bin/bash
adduser --no-create-home --disabled-loging --shell /bin/false --gecos "Prometheus user" prometheus
adduser --no-create-home --disabled-loging --shell /bin/false --gecos "Node Exporter user" node_exporter
adduser --no-create-home --disabled-loging --shell /bin/false --gecos "Alertmanager User" alertmanager 

mkdir /etc/prometheus
mkdir /etc/alertmanager
mkdir /etc/alertmanager/template

# /var/lib/ to store app data
mkdir /var/lib/prometheus
mkdir -p /var/lib/alertmanager/data

touch /etc/prometheus/prometheus.yml
touch /etc/alertmanager/alertmanager.yml

chown -R prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus
chown -R alertmanager:alertmanager /etc/alertmanager
chown -R alertmanager:alertmanager /var/lib/alertmanager

wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz

tar xvf prometheus-2.26.0.linux-amd64.tar.gz

cp prometheus-2.26.0.linux-amd64/prometheus /usr/local/bin
cp prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool

cp -r prometheus-2.26.0.linux-amd64/consoles /etc/prometheus
cp -r prometheus-2.26.0.linux-amd64/console_libraries /etc/prometheus
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries

cp prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
rm -rf prometheus-2.26.0.linux-amd64.tar.gz prometheus-2.26.0.linux-amd64

# prometheus.yml

echo "global:
  scrape_interval: 1s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 1s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    scrape_interval: 1s
    static_configs:
      - targets: ['localhost:9100']" | sudo tee /etc/prometheus/prometheus.yml

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
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/prometheus.service

systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus

# cleanup
rm prometheus-2.26.0.linux-amd64.tar.gz
rm node_exporter-1.1.2.linux-amd64.tar.gz
rm grafana_4.6.3_amd64.deb

rm -rf prometheus-2.26.0.linux-amd64
rm -rf node_exporter-1.1.2.linux-amd64