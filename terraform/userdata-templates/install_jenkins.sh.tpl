#!/bin/bash
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt update
apt install default-jdk -y
apt install jenkins -y
apt install nodejs -y
apt install npm -y
npm cache clean -f
npm install -g n
n stable
PATH="$PATH"
apt install git -y
apt install awscli -y
npm install -g @angular/cli
systemctl enable jenkins.service
systemctl stop jenkins.service
echo 'JAVA_ARGS="-Djenkins.install.runSetupWizard=false"' >> /etc/default/jenkins
mkdir /var/lib/jenkins/init.groovy.d/
cat > /var/lib/jenkins/init.groovy.d/basic-security.groovy <<EOF
#!groovy
import hudson.EnvVars;
import hudson.slaves.EnvironmentVariablesNodeProperty;
import hudson.slaves.NodeProperty;
import hudson.slaves.NodePropertyDescriptor;
import hudson.util.DescribableList;
import jenkins.model.*
import hudson.security.*
import hudson.util.*
import jenkins.install.*
def instance = Jenkins.getInstance()
def hudsonRealm = new HudsonPrivateSecurityRealm(false)
instance.setInstallState(InstallState.INITIAL_SETUP_COMPLETED)
hudsonRealm.createAccount('admin','Qwerty123!')
instance.setSecurityRealm(hudsonRealm)
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
public createGlobalEnvironmentVariables(String key, String value){

       Jenkins instance = Jenkins.getInstance();

       DescribableList<NodeProperty<?>, NodePropertyDescriptor> globalNodeProperties = instance.getGlobalNodeProperties();
       List<EnvironmentVariablesNodeProperty> envVarsNodePropertyList = globalNodeProperties.getAll(EnvironmentVariablesNodeProperty.class);

       EnvironmentVariablesNodeProperty newEnvVarsNodeProperty = null;
       EnvVars envVars = null;

       if ( envVarsNodePropertyList == null || envVarsNodePropertyList.size() == 0 ) {
           newEnvVarsNodeProperty = new hudson.slaves.EnvironmentVariablesNodeProperty();
           globalNodeProperties.add(newEnvVarsNodeProperty);
           envVars = newEnvVarsNodeProperty.getEnvVars();
       } else {
           envVars = envVarsNodePropertyList.get(0).getEnvVars();
       }
       envVars.put(key, value)
       instance.save()
}
createGlobalEnvironmentVariables('s3_address','${aws_s3_bucket}')
createGlobalEnvironmentVariables('backend_ip','${backend_ip}')
createGlobalEnvironmentVariables('dbuser','${db_user}')
createGlobalEnvironmentVariables('dbpass','${db_pass}')
createGlobalEnvironmentVariables('dburl','${db_url}')
createGlobalEnvironmentVariables('dbname','${db_name}')
EOF

echo 'JENKINS_ARGS="--prefix=/jenkins"' >> /etc/default/jenkins
systemctl restart jenkins.service
cp /var/cache/jenkins/war/WEB-INF/lib/cli-2.277.4.jar /tmp/cli-2.277.4.jar

sleep 50
java -jar /tmp/cli-2.277.4.jar -s http://localhost:8080/jenkins/ -auth admin:Qwerty123! install-plugin git:4.7.1 -restart
sleep 90
java -jar /tmp/cli-2.277.4.jar -s http://localhost:8080/jenkins/ -auth admin:Qwerty123! restart 
git clone https://github.com/DevOpsAvengaTeamB/Project.git
sleep 60
java -jar /tmp/cli-2.277.4.jar -s http://localhost:8080/jenkins/ -auth admin:Qwerty123! create-job frontend < Project/Jobs/front2.xml
java -jar /tmp/cli-2.277.4.jar -s http://localhost:8080/ -auth admin:Qwerty123! create-job backend < Project/Jobs/backend-config.xml
java -jar /tmp/cli-2.277.4.jar -s http://localhost:8080/jenkins/ -auth admin:Qwerty123! build frontend
java -jar /tmp/cli-2.277.4.jar -s http://localhost:8080/ -auth admin:Qwerty123! build backend
