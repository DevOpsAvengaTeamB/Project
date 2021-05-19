#!/bin/bash

# Prometheus installation

adduser --no-create-home --disabled-login --shell /bin/false --gecos "Prometheus Monitoring User" prometheus
adduser --no-create-home --disabled-login --shell /bin/false --gecos "Node Exporter User" node_exporter

mkdir /etc/prometheus
mkdir /etc/alertmanager



# Use /var/lib/<package_name> to store app data

mkdir /var/lib/prometheus

touch /etc/prometheus/prometheus.yml


chown -R prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus


wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
wget https://dl.grafana.com/oss/release/grafana_7.5.5_amd64.deb

tar xvzf prometheus-2.26.0.linux-amd64.tar.gz
tar xvzf node_exporter-1.1.2.linux-amd64.tar.gz

cp prometheus-2.26.0.linux-amd64/prometheus /usr/local/bin/
cp prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
cp -r prometheus-2.26.0.linux-amd64/consoles /etc/prometheus
cp -r prometheus-2.26.0.linux-amd64/console_libraries /etc/prometheus
cp node_exporter-1.1.2.linux-amd64/node_exporter /usr/local/bin/

chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
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
      - targets: ['0.0.0.0:9100']" |    tee /etc/prometheus/prometheus.yml


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


# grafana installation

apt-get install -y libfontconfig
dpkg -i grafana_7.5.5_amd64.deb

/bin/systemctl daemon-reload
/bin/systemctl enable grafana-server
/bin/systemctl start grafana-server


#grafana yml

# echo "[server]
# domain = ec2-3-67-194-16.eu-central-1.compute.amazonaws.com
# root_url = %(protocol)s://%(domain)s:%(http_port)s/grafana/
# serve_from_sub_path = true" | tee /etc/grafana/grafana.ini

# sed -i "
# s/;domain = localhost/domain = ${}/;
# s/;serve_from_sub_path = false/serve_from_sub_path = true/" | tee /etc/grafana/grafana.ini



#grafana provisioning

echo "apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    # Access mode - proxy (server in the UI) or direct (browser in the UI).
    access: proxy
    httpMethod: POST
    url: http://localhost:9090
    jsonData:
      exemplarTraceIdDestinations:
        # Field with internal link pointing to data source in Grafana.
        # datasourceUid value can be anything, but it should be unique across all defined data source uids.
        - datasourceUid: my_jaeger_uid
          name: traceID

        # Field with external link.
        - name: traceID
          url: 'http://localhost:3000/explore?orgId=1&left=%5B%22now-1h%22,%22now%22,%22Jaeger%22,%7B%22query%22:%22$${__value.raw}%22%7D%5D'" | tee /etc/grafana/provisioning/datasources/datasource.yml

wget https://grafana.com/api/dashboards/13978/revisions/1/download -O /etc/grafana/provisioning/dashboards/nodes_rev1.json

#grafana dashboards

echo "apiVersion: 1

providers:
  # <string> an unique provider name. Required
  - name: 'Prometheus'
    # <int> Org id. Default to 1
    orgId: 1
    # <string> name of the dashboard folder.
    folder: ''
    # <string> folder UID. will be automatically generated if not specified
    folderUid: ''
    # <string> provider type. Default to 'file'
    type: file
    # <bool> disable dashboard deletion
    disableDeletion: false
    # <int> how often Grafana will scan for changed dashboards
    updateIntervalSeconds: 10
    # <bool> allow updating provisioned dashboards from the UI
    allowUiUpdates: false
    options:
      # <string, required> path to dashboard files on disk. Required when using the 'file' type
      path: /var/lib/grafana/dashboards
      # <bool> use folder names from filesystem to create folders in Grafana
      foldersFromFilesStructure: true" | tee /etc/grafana/provisioning/dashboards/dashboard.yml


/bin/systemctl restart grafana-server



# cleanup

rm prometheus-2.26.0.linux-amd64.tar.gz
rm node_exporter-1.1.2.linux-amd64.tar.gz
rm grafana_7.5.5_amd64.deb

rm -rf prometheus-2.26.0.linux-amd64
rm -rf node_exporter-1.1.2.linux-amd64
