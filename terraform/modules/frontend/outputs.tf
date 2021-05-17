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
output "s3_address" {
  value = aws_s3_bucket.myBucket.bucket
}
output "iam_profile" {
  value = aws_iam_instance_profile.front_profile.id
}

