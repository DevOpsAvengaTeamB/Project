
variable "ami" {
 description = "Ubuntu 20.04"
 default = "ami-08962a4068733a2b6"
}
variable "web_private_ip" {
  type = string
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
