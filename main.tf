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
module "frontend" {
  source = "./modules/frontend/"
  vpc-id = module.network.vpc-id
  subnet-pub-a-id = module.network.subnet-pub-a-id
}