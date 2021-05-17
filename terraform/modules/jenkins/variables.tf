variable "instance-ami" {
  type = list(string)
  default = [
    "ami-0e9e6ba6d3d38faa8",
    "ami-0f7cd40eac2214b37",
    "ami-0556a158653dad0ba"
  ]
  description = "List of AMIs"
}

variable "instance-type" {
  type = list(string)
  default = [
    "t2.micro",
    "t2.medium",
    "t2.large"
  ]
}

variable "userdata-path" {
  type    = string
  default = "userdata-templates"
}
variable "vpc-id" {}
variable "key-name" {}
variable "id-sg-bastion" {}
variable "id-sg-jenkins" {}
variable "id-sg-elb" {}
variable "id-sg-private" {}
variable "subnet-pub-a-id" {}
variable "subnet-pub-b-id" {}
variable "subnet-priv-a-id" {}
variable "subnet-priv-b-id" {}
variable "jenkins_user" {
  description = "root"
}
variable "jenkins_pass" {
  description = "root"
}
variable "alb_is_internal" {
  description = "Determines if the ALB is internal. Default: false"
  default     = false
}

variable "alb_name" {
  description = "The name of the ALB as will show in the AWS EC2 ELB console."
  default     = "my-alb"
}

variable "alb_protocols" {
  description = "A comma delimited list of the protocols the ALB accepts. e.g.: HTTPS"
  default     = "HTTP"
}

variable "backend_port" {
  description = "The port the service on the EC2 instances listen on."
  default     = 80
}
variable "backend_protocol" {
  description = "The protocol the backend service speaks. Options: HTTP, HTTPS, TCP, SSL (secure tcp)."
  default     = "HTTP"
}
variable "health_check_path" {
  description = "The URL the ELB should use for health checks. e.g. /health"
  default     = "/"
}
variable "s3_address" {}
variable "iam_profile" {}
