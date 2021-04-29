output "key-name" {
  description = "Key pair name"
  value       = var.key-name
}
output "id-sg-bastion" {
  description = "The ID of security group for remote connection to bastion host"
  value       = aws_security_group.bastion-access.id
}
output "id-sg-private" {
  description = "The ID of security group that allows connection to private area hosts from bastion over SSH"
  value       = aws_security_group.private-access.id
}
output "id-sg-jenkins" {
  description = "The ID of security group for Jenkins"
  value       = aws_security_group.jenkins.id
}
