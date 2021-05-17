data "template_file" "user_data1" {
  template = "${file("./userdata-templates/install_jenkins.sh.tpl")}"

  vars = {
      aws_s3_bucket = var.s3_address
  }
}
resource "aws_launch_template" "jenkins-launch-tmpl" {
  name                    = "Jenkins"
  image_id                = var.instance-ami[1]
  instance_type           = var.instance-type[1]
  key_name = "key"
  iam_instance_profile {
  name = "front_profile"
  }
  vpc_security_group_ids  = ["${var.id-sg-jenkins}", "${var.id-sg-private}"]
  disable_api_termination = true

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
    }
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Jenkins"
    }
  }
  user_data = base64encode(data.template_file.user_data1.rendered)

  tags = {
    Name = "jenkins-launch-tmpl"
  }
}

resource "aws_autoscaling_group" "jenkins" {
  desired_capacity = 1
  max_size         = 1
  min_size         = 1
  # vpc_zone_identifier = ["${var.subnet-pub-a-id}", "${var.subnet-pub-b-id}"]
  vpc_zone_identifier = ["${var.subnet-priv-a-id}", "${var.subnet-priv-b-id}"]
  launch_template {
    id      = aws_launch_template.jenkins-launch-tmpl.id
    version = "$Latest"
  }
}


resource "aws_alb" "elb" {
  name            = var.alb_name
  load_balancer_type = "application"
  subnets         = ["${var.subnet-pub-a-id}", "${var.subnet-pub-b-id}"]
  security_groups = ["${var.id-sg-elb}"]
  internal        = var.alb_is_internal

  tags = map("Name", format("%s-tg", var.alb_name))
}

resource "aws_alb_target_group" "target_group" {
  name     = "${var.alb_name}-tg"
  port     = 8080
  protocol = upper(var.backend_protocol)
  vpc_id   = var.vpc-id

  health_check {
    interval            = 30
    port                = 8080
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    protocol            = var.backend_protocol
  }


  tags = map("Name", format("%s-tg", var.alb_name))
}

resource "aws_alb_listener" "alb_jenkins_http" {
  load_balancer_arn = aws_alb.elb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }

 # count = trimspace(element(split(",", var.alb_protocols), 1)) == "HTTP" || trimspace(element(split(",", var.alb_protocols), 2)) == "HTTP" ? 1 : 0
}

resource "aws_autoscaling_attachment" "asg_attachment"{
autoscaling_group_name = aws_autoscaling_group.jenkins.id
alb_target_group_arn = aws_alb_target_group.target_group.arn
}
