
resource "aws_security_group" "default" {
  name        = "instance_sg"
  vpc_id      = "${}"      !!!!!!!

 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "$(var.cidr)"
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
  ami = "${var.aws_ami}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  subnet_id              = "${}"   !!!!!
  user_data              = "${file("userdata.sh")}"

  }