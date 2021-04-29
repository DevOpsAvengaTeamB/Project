# SET PROVIDER - AMAZON WEB SERVICES
provider "aws" {
  region = "${var.aws-region}"
  #access_key = var.access_key
  #secret_key = var.secret_key
}
terraform {
  required_version = "> 0.12.08"
}

module "network" {
  source          = "./modules/network/"
}
  
module "security" {
  source = "./modules/security/"
  vpc-id = module.network.vpc-id
  all-ip = module.network.all-ip
}
    
module "frontend" {
  source = "./modules/frontend/"
  vpc-id = module.network.vpc-id
  subnet-priv-a-id = module.network.subnet-priv-a-id
}
    
module "monitoring_loging"{
    source = "./modules/monitoringloging"
    #version = "0.1"
    vpc_id = module.network.vpc-id
    subnet = module.network.subnet-priv-a-id
  }
