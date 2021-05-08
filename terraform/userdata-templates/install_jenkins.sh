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

systemctl enable jenkins.service
systemctl start jenkins.service

# Downloading Jenkins CLI
cp /var/cache/jenkins/war/WEB-INF/lin/cli-2.277.4.jar /tmp/cli-2.277.4.jar

# Installing Jenkins Plugins and restart Jenkins
#wget http://localhost:8080/jnplJars/jenkins-cli.jar
java -jar jenkins-cli.jar -s "http://localhost:8080/" -auth ${jenkins_user}:${jenkins_pass} install-plugin git github terraform:1.0.9 ssh:2.6.1 job-dsl:1.76 workflow-aggregator:2.6 blueocean:1.21.0 pipeline-maven chucknorris:1.2 htmlpublisher:1.21 buildgraph-view:1.8 copyartifact:1.43 jacoco:3.0.4 greenballs locale:1.4 envinject:2.3.0 -restart
