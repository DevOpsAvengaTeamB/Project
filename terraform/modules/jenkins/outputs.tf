output "alb-id" {
  description = "The ID of security group for Jenkins"
  value       = aws_alb.elb.id
}
output "alb-arn" {
  description = "The ID of security group for Jenkins"
  value       = aws_alb.elb.arn
}
output "aws_alb_listener-arn" {
  description = "The ID of security group for Jenkins"
  value       = aws_alb_listener.alb_jenkins_http.arn
}
