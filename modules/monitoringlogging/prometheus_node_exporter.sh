#don't work
sudo adduser --no-create-home --disabled-loging --shell /bin/false --gecos "Prometheus user" prometheus
mkdir /etc/prometheus
mkdir /var/lib/prometheus/

#download node_exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
tar -xzvf node_exporter-1.1.2.linux-amd64.tar.gz
mv node_exporter-1.1.2.linux-amd64.tar.gz /home/prometheus/node_exporter
rm node_exporter-1.1.2.linux-amd64.tar.gz
chown -R prometheus:prometheus /home/prometheus/node_exporter

#Add node_exporter as system service
tee -a /etc/systemd/system/node_exporter.service << END
[Unit]
Description=Nude Exporter
Wants=network-online.target
After=network-online.target
[Service]
User=prometheus
ExecStart=/home/prometheus/node_exporter/node_exporter
[Install]0
WantedBy=default.target
END

systemctl daemon-reload
systemctl start node_exporter
system enable node_exporter

