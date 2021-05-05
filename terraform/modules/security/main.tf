# MY IP ADDRESS LOCATION
data "http" "my-ipaddress" {
  url = var.my-ip
}

# CREATE SECURITY GROUPS WITH RULES
# security group allows remote connection to bastion host
resource "aws_security_group" "bastion-access" {
  name        = "bastion-access"
  description = "Allow access to bastion host"
  vpc_id      = var.vpc-id
  tags = {
    Name = "${var.sg-name[0]}"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my-ipaddress.body)}/32"]
    description = "Allow SSH connection to bastion host"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# CREATE SECURITY GROUPS WITH RULES
# security group allows remote connection to bastion host
resource "aws_security_group" "elb" {
  name        = "elb-access"
  description = "Allow access elb"
  vpc_id      = var.vpc-id
  tags = {
    Name = "${var.sg-name[3]}"
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my-ipaddress.body)}/32"]
    description = "Allow 80 port for my ip"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# security group allows connection to private area hosts from bastion over SSH
resource "aws_security_group" "private-access" {
  name        = "private-access"
  description = "Allow access to private network hosts"
  vpc_id      = var.vpc-id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.all-ip}"]
  }
  tags = {
    Name = "${var.sg-name[1]}"
  }
}
resource "aws_security_group_rule" "private-access-ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.private-access.id
  source_security_group_id = aws_security_group.bastion-access.id
}
# Jenkins security groups
resource "aws_security_group" "jenkins" {
  name        = "jenkins"
  description = "For jenkins jobs"
  vpc_id      = var.vpc-id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.all-ip}"]
  }
  tags = {
    Name = "${var.sg-name[2]}"
  }
}
resource "aws_security_group_rule" "jenkins-ingress" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["${var.all-ip}"]
  security_group_id = "${aws_security_group.jenkins.id}"
}
# resource "aws_security_group_rule" "jenkins-egress" {
#   type      = "egress"
#   from_port = 0
#   to_port   = 65500
#   protocol  = "tcp"
#   # cidr_blocks = ["0.0.0.0/0"]
#   cidr_blocks       = ["${var.all-ip}"]
#   security_group_id = "${aws_security_group.jenkins.id}"
# }
resource "aws_security_group_rule" "jenkins-ingress-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.jenkins.id
}
# resource "aws_security_group_rule" "jenkins-egress-ssh" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 65500
#   protocol          = "tcp"
#   cidr_blocks       = ["${var.all-ip}"]
#   security_group_id = "${aws_security_group.jenkins.id}"
# }
#resource "aws_key_pair" "key" {
#key_name   = var.key-name
#public_key = var.pub-key
#}
