# FOR eu-west-3 ONLY!
# [0] - for Amazon Linux 2
# [1] - for Ubuntu 20.04
# [2] - for RHEL 8
variable "instance-ami" {
  type = list
  default = [
    "ami-0f8e9f8dde1600888",
    "ami-0d6aecf0f0425f42a",
    "ami-0556a158653dad0ba"
  ]
  description = "List of AMIs"
}
# for eu-west-3
# [0] - t.micro
# [1] - t.medium
# [2] - t.xlarge
variable "instance-type" {
  type = list
  default = [
    "t2.micro",
    "t2.medium",
    "t2.xlarge"
  ]
}
variable "name-tag" {
  type = list
  default = [
    "dos-bastion"
  ]
}
variable "name-prefix" {
  default = "launch-temlate"
}
variable "userdata-path" {
  type    = string
  default = "./userdata-templates/"
}
variable "key-name" {
type = string
default = "public"
description = "per key"
}
variable "id-sg-bastion" {}
variable "id-sg-private" {}
variable "subnet-pub-a-id" {}
variable "subnet-pub-b-id" {}
variable "subnet-priv-a-id" {}
variable "subnet-priv-b-id" {}
