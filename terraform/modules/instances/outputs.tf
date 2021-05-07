# FOR eu-west-3 ONLY!
# [0] - for Amazon Linux 2
# [1] - for Ubuntu 18.04
# [2] - for RHEL 8
output "instance-ami" {
  description = "List of AMI in eu-west-3"
  value       = var.instance-ami
}
# for eu-west-3
# [0] - t.micro
# [1] - t.medium
# [2] - t.xlarge
output "instance-type" {
  description = "List of instance types in eu-west-3"
  value       = var.instance-type
}
