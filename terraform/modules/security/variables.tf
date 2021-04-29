variable "my-ip" {
  type        = string
  default     = "http://ipv4.icanhazip.com"
  description = "My ip address"
}
variable "sg-name" {
  type = list(string)
  default = [
    "bastion-access",
    "private-access",
    "jenkins"
  ]
  description = "List of security group's names"
}
variable "key-name" {
  type        = string
  default     = "key"
  description = "Key pair name"
}
#variable "pub-key" {
#type        = "string"
#default     = "ssh-rsa "
#description = "Public part of key pair"
#}
variable "vpc-id" {
  description = "VPC ID"
}
variable "all-ip" {
  description = "CIDR block 0.0.0.0/0"
}
