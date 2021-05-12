output "instance_id_monitoring" {
    description= "ID of the EC2 monitoring instance"
    value=aws_instance.ec2_instance_monitoring.id
}

output "instance_monitoring_private_ip" {
    description= "Private IP of the EC2 monitoring instance"
    value=aws_instance.ec2_instance_monitoring.private_ip
}

output "instance_id_logging" {
    description= "ID of the EC2  logging instance"
    value=aws_instance.ec2_instance_logging.id
}

output "instance_logging_private_ip" {
    description= "Private IP of the EC2 logging instance"
    value=aws_instance.ec2_instance_logging.private_ip
}

output "security_group_id" {
    description= "ID of monitoring security group "
    value="${aws_security_group.monitoring.id}"
}

