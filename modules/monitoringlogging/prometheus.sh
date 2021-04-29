#!/bin/bash
sudo adduser --no-create-home --disabled-loging --shell /bin/false --gecos "Prometheus user" prometheus
mkdir /etc/prometheus
mkdir /var/lib/prometheus/

wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz
tar xvf prometheus-2.26.0.linux-amd64.tar.gz

cp prometheus-2.26.0.linux-amd64/prometheus /usr/local/bin
cp prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
cp -r prometheus-2.26.0.linux-amd64/consoles /etc/prometheus
cp -r prometheus-2.26.0.linux-amd64/console_libraries /etc/prometheus

cp prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
rm -rf prometheus-2.26.0.linux-amd64.tar.gz prometheus-2.26.0.linux-amd64

echo "global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'node_exporter'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9100']" | sudo tee /etc/prometheus/prometheus.yml
