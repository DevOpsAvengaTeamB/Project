variable "vpc-id" {
  type = string
}
variable "subnet-priv-a-id" {
  type = string
}
variable "subnet-priv-b-id" {
  type = string
}
variable "subnet-pub-a-id" {
  type = string
}
variable "subnet-pub-b-id" {
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
#output "web_private_ip" {
#  value = aws_instance.web.private_ip
#}
