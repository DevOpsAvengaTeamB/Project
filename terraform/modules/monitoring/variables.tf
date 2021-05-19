variable "ami" {
    description="The type of ami (Ubuntu 20.04 ) eu-west-3"
    type = string
    default="ami-0f7cd40eac2214b37"
}

variable "instance_type" {
    description = "The type of EC2 instance to run (t2.medium)"
    type = string
    default="t2.medium"
}
variable "vpc-id" {
  type = string
}
variable "subnet-priv-a-id" {
  type = string
}
variable "subnet-priv-b-id" {
  type = string
}
variable "alb-id" {
  type = string
}
variable "alb-arn" {
  type = string
}
variable "aws_alb_listener-arn" {
  type = string
}
