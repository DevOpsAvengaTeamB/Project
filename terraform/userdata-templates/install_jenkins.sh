#! /bin/bash

# Install Jenkins and Java

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt update
apt install default-jdk -y
apt install maven -y
apt install nodejs -y
apt install npm -y
apt install jenkins -y

echo ‘JAVA_ARGS=”-Djenkins.install.runSetupWizard=false”’ >> /etc/default/jenkins
# ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
# Jenkins admin user setup
mkdir -p /var/lib/jenkins/init.groovy.d
#touch /var/lib/jenkins/init.groovy.d/basic-security.groovy
cat > /var/lib/jenkins/init.groovy.d/basic-security.groovy << EOF
#!groovy
import jenkins.model.*
import hudson.security.*
import hudson.util.*
import jenkins.install.*
def instance = Jenkins.getInstance()
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)
def user = instance.getSecurityRealm().createAccount('${jenkins_user}', '${jenkins_pass}')
user.save()
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(false)
instance.setAuthorizationStrategy(strategy)
instance.save()
EOF

#chown jenkins:jenkins /var/lib/jenkins/init.groovy.d/basic-security.groovy

systemctl restart jenkins.service
cp /var/cache/jenkins/war/WEB-INF/lib/cli-2.277.4.jar /tmp/cli-2.277.4.jar

sleep 50
java -jar /tmp/cli-2.277.4.jar -s http://localhost:8080/ -auth admin:Qwerty123! install-plugin git:4.7.1 -restart
sleep 90
java -jar /tmp/cli-2.277.4.jar -s http://localhost:8080/ -auth admin:Qwerty123! restart 
