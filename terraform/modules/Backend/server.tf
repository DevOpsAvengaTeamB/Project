# Define the security group for backend
resource "aws_security_group" "backend" {
 name = "for backend"

 ingress {
 from_port = 8080
 to_port = 8080
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"] 
 }
 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  } 
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 vpc_id = var.vpc-id
}

#Getting latest Ubuntu AMI id
data "aws_ami" "ubuntu" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    owners = ["099720109477"] 
}


# Define instance for backend
resource "aws_launch_configuration" "Backend" {
 image_id = data.aws_ami.ubuntu.id
 instance_type = "t2.micro"
 #key_name = "2vn"
 user_data = file("./modules/Backend/userdata.sh")
 security_groups = [aws_security_group.backend.id]
 lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "back_rule" {
  listener_arn = var.aws_alb_listener-arn
    action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.backend.arn
  }
  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }  
}
resource "aws_alb_target_group" "backend" {
  name = "backend-tg-lb"
  port = 8080
  protocol = "HTTP"
  vpc_id = var.vpc-id
      health_check {
        port = 8080
        protocol = "HTTP"
        matcher = "200"
        interval = 25        
      }
}
resource "aws_autoscaling_group" "for_backend_asg" {
  launch_configuration = aws_launch_configuration.Backend.name
  vpc_zone_identifier  = [ var.subnet-priv-a-id, var.subnet-priv-b-id]
  target_group_arns = [ aws_lb_target_group.backend.arn ]
  desired_capacity = 1
  max_size         = 1
  min_size         = 1
  health_check_type    = "ELB"
  tag {
    key                 = "Name"
    value               = "Back"
    propagate_at_launch = true
  }
}
