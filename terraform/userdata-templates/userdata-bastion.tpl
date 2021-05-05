#!/bin/bash
timedatectl set-timezone Europe/Kiev
######################################
# Installing Node Exporter user-data #
######################################

# Downloading the node exporter package
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz -P /tmp

# Unpacking the tarball
tar xf /tmp/node_exporter-0.18.1.linux-amd64.tar.gz -C /opt/

# Moving the node export binary to /usr/local/bin
mv /opt/node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin/

# Creating a node_exporter user to run the node exporter service
useradd -rs /bin/false node_exporter

# Creating a node_exporter service file under systemd
cat <<EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Enabling the node exporter service to the system startup
systemctl enable node_exporter
# Reloading the system daemon and starting the node exporter service
systemctl daemon-reload
systemctl start node_exporter


