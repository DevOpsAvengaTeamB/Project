# Define the security group for backend
resource "aws_security_group" "backend"{
 name = "for backend"
 description = "Allow traffic from bastion and frontend"
 ingress {
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["192.168.0.0/16"]
 }
 ingress {
 from_port = 8080
 to_port = 8080
 protocol = "tcp"
 cidr_blocks = ["${var.web_private_ip}/32"] 
 }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 vpc_id = var.vpc-id
}


# Define instance for backend
resource "aws_instance" "Backend" {
 ami = var.ami
 instance_type = "t2.micro"
 #key_name = "2vn"
 subnet_id = var.subnet-priv-a-id
 user_data = file("./userdata.sh")
 vpc_security_group_ids = [aws_security_group.backend.id]
 tags ={
 Name = "backend"
 }
}
