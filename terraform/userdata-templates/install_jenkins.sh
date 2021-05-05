#! /bin/bash

###################################
# Installing and settings Jenkins #
###################################

#!/bin/bash

# Install Jenkins and Java

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt update
apt install default-jdk -y
# apt install maven -y
# apt install nodejs -y
# apt install npm -y
apt install jenkins -y

# Automate Jenkins admin user setup
mkdir /var/lib/jenkins/init.groovy.d/

cat > /var/lib/jenkins/init.groovy.d/basic-security.groovy <<EOF
#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()
println \"--> creating local user 'admin' \"
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin','Qwerty123!')
instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
EOF

systemctl enable jenkins.service
systemctl start jenkins.service
sleep 30
systemctl stop jenkins.service
sleep 30
rm -rf /var/lib/jenkins/init.groovy.d
systemctl start jenkins.service
