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

resource "aws_security_group" "frontend" {
  name        = "frontend_sg"
  vpc_id      = var.vpc-id      

 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
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



resource "aws_launch_configuration" "frontend" {
  depends_on = [aws_s3_bucket.myBucket]
  name_prefix = "frontend"
  image_id = data.aws_ami.ubuntu.id 
  instance_type = "t2.micro"
  security_groups = [aws_security_group.frontend.id]
  key_name = "key"
  user_data = "${data.template_file.user_data.rendered}"
  #user_data = file("./modules/frontend/userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.front_profile.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "s3read" {
  name = "s3read"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "front_profile" {
  name = "front_profile"
  role = aws_iam_role.s3read.name
}

resource "aws_iam_role_policy" "s3read" {
  name = "s3read"
  role = "${aws_iam_role.s3read.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}


resource "aws_lb_listener_rule" "front_rule" {
  listener_arn = var.aws_alb_listener-arn
  priority     = 3
  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.frontend.arn

  }
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
resource "aws_alb_target_group" "frontend" {
  name     = "frontend-tg-lb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    port     = 80
    protocol = "HTTP"
    timeout  = 5
    interval = 10
  }
}

resource "aws_autoscaling_attachment" "asg_atach" {
  autoscaling_group_name = aws_autoscaling_group.web.id
  alb_target_group_arn   = aws_alb_target_group.frontend.arn
}

resource "aws_autoscaling_group" "web" {
  name = "${aws_launch_configuration.frontend.name}-asg"
  depends_on = [aws_launch_configuration.frontend]
  min_size             = 1
  desired_capacity     = 2
  max_size             = 2
  health_check_type    = "ELB"
  health_check_grace_period = 1200
  launch_configuration = aws_launch_configuration.frontend.name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  vpc_zone_identifier  = [
    var.subnet-priv-a-id,
    var.subnet-priv-b-id
  ]

  # Required to redeploy without an outage.
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }

}

resource "aws_s3_bucket" "myBucket" {
  bucket = "${var.my_bucket_name}"
  acl    = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

data "template_file" "user_data" {
  template = "${file("./modules/frontend/userdata.sh.tpl")}"

  vars = {
      aws_s3_bucket = "${aws_s3_bucket.myBucket.bucket}"
      elastic_ip = var.elastic_ip
      prometheus_ip = var.prometheus_ip
      
  }
}
