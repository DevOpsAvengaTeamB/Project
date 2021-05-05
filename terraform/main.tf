# SET PROVIDER - AMAZON WEB SERVICES
provider "aws" {
  region     = var.aws-region
  access_key = var.access_key
  secret_key = var.secret_key
}

terraform {
  required_version = "> 0.12.08"
}

module "network" {
  source = "./modules/network/"
}

module "security" {
  source = "./modules/security/"
  vpc-id = module.network.vpc-id
  all-ip = module.network.all-ip
}

# Create Instance
module "instances" {
  source                = "./modules/instances/"
  key-name              = module.security.key-name
  id-sg-bastion         = module.security.id-sg-bastion
  id-sg-private         = module.security.id-sg-private
  subnet-pub-a-id       = module.network.subnet-pub-a-id
  subnet-pub-b-id       = module.network.subnet-pub-b-id
  subnet-priv-a-id      = module.network.subnet-priv-a-id
  subnet-priv-b-id      = module.network.subnet-priv-b-id
}

# Create Jenkins
module "jenkins" {
  source                         = "./modules/jenkins/"
  key-name                       = module.security.key-name
  id-sg-bastion                  = module.security.id-sg-bastion
  id-sg-private                  = module.security.id-sg-private
  id-sg-jenkins                  = module.security.id-sg-jenkins
  id-sg-elb                      = module.security.id-sg-elb
  vpc-id                         = module.network.vpc-id
  subnet-pub-a-id                = module.network.subnet-pub-a-id
  subnet-pub-b-id                = module.network.subnet-pub-b-id
  subnet-priv-a-id               = module.network.subnet-priv-a-id
  subnet-priv-b-id               = module.network.subnet-priv-b-id
  jenkins_user                   = var.jenkins_user
  jenkins_pass                   = var.jenkins_pass
}
 
module "frontend" {
  source = "./modules/frontend/"
  vpc-id = module.network.vpc-id
  subnet-priv-a-id = module.network.subnet-priv-a-id
}
#module "backend" {
#  source = "./modules/Backend/"
#  vpc-id = module.network.vpc-id
#  subnet-priv-a-id = module.network.subnet-priv-a-id
#  subnet-priv-b-id = module.network.subnet-priv-b-id
#  web_private_ip = module.frontend.web_private_ip    
#  }

    
/*module "monitoring_loging"{
    source = "./modules/monitoringloging"
    #version = "0.1"
    vpc_id = module.network.vpc-id
    subnet = module.network.subnet-priv-a-id
  }*/
