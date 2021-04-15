variable "access_key" {
  description = "The AWS access key."
}

variable "secret_key" {
  description = "The AWS secret key."
}

variable "region" {
  description = "The AWS region to create resources in."
  default = "us-east-2"
}

variable "availability_zone" {
  description = "The availability zone"
  default = "us-east-2a"
}

variable "vpc_name" {
  description = "Bravo VPC"
  type        = string
}

variable "private_subnet_name" {
  description = "private subnet"
  type        = string
}

variable "public_subnet_name" {
  description = "public subnet"
  type        = string
}

variable "bastion_sg_name" {
  description = "The bastion security group name to allow via ssh"
  type        = string
}

variable "jenkins_sg_name" {
  description = "The jenkins security group name"
  type        = string
}

variable "jenkins_name" {
  description = "Jenkins server"
  default = "jenkins"
}

variable "bastion_name" {
  description = "Bastion Host"
  default = "bastion"
}

variable "amis" {
  description = "Which AMI to spawn. Defaults to the Weave ECS AMIs: https://github.com/weaveworks/integrations/tree/master/aws/ecs."
  default = {
    us-east-2 = "ami-08962a4068733a2b6"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "public"
  description = "SSH key name in your AWS account for AWS instances."
}
