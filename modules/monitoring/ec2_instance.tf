resource "aws_instance" "ec2_instance_monitoring" {
    ami=var.ami
    instance_type=var.instance_type
    key_name="${aws_key_pair.ssh.id}"
    vpc_security_group_ids=["${aws_security_group.ec2_instance_monitoring.id}"]
    subnet_id=var.subnet_id
    monitoring=true
    user_data="${file("prometheus.sh")}"

    tags={
        Name="prometheus-server"
    }
}

resource "aws_instance" "ec2_instance_logging" {
    ami=var.ami
    instance_type=var.instance_type
    key_name="${aws_key_pair.ssh.id}"
    vpc_security_group_ids=["${aws_security_group.ec2_instance_monitoring.id}"]
    subnet_id=var.subnet_id
    monitoring=true
    user_data="${file("elk.sh")}"

    tags={
        Name="Logging Instance"
    }
}