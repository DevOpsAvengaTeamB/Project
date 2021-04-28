resource "aws_security_group" "frontend" {
  name        = "frontend_sg"
  vpc_id      = var.vpc-id      

 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami = var.aws_ami
  #key_name = "aws"
  vpc_security_group_ids = [aws_security_group.frontend.id]
  subnet_id              = var.subnet-pub-a-id
  user_data              = file("/home/mgavrysh/gitprog/Project/FRONTEND/userdata.sh")
  tags = {
    Name = "web_server"
  }
}
