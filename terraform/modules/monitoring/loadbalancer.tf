
resource "aws_security_group" "loadbalancer" {
  name="Loadbalancer_Bravo"
  description="Grafana and Kibana"
  vpc_id=var.vpc_id
  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
    description="Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description="Kibana"
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description="Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags={
    Name="lb_scgroup_bravo"
  }
}


# create-load-balancer 

resource "aws_lb" "monitoring" {
  name               = "monitoring"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer.id]
  subnets            = ["${var.public_subnet_a_id}", "${var.public_subnet_b_id}"]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Name = "LB monitoring"
  }
}

# create target group

resource "aws_lb_target_group" "monitoring" {
  name     = "${var.alb_name}-tg"
  port     = 3000
  protocol = "HTTP"
  target_type = ${aws_instance.ec2_instance_monitoring.id}
  vpc_id   = var.vpc-id

  tags={
        Name="monitoring-tg-teamB"
    }
}

resource "aws_lb_target_group" "logging" {
  name     = "${var.alb_name}-tg"
  port     = 5601
  protocol = "HTTP"
  target_type = ${aws_instance.ec2_instance_logging.id}
  vpc_id   = var.vpc-id

  tags={
        Name="loging-tg-teamB"
    }
}



resource "aws_lb_listener" "monitoring" {
  load_balancer_arn = aws_lb.monitoring.arn
  port              = "3000"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.monitoring.arn
  }
}

resource "aws_lb_listener" "logging" {
  load_balancer_arn = aws_lb.logging.arn
  port              = "5601"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.logging.arn
  }
}

# Weighted Forward action

resource "aws_lb_listener_rule" "monitoring_rule" {
  listener_arn = aws_lb_listener.monitoring.arn
  priority     = 100

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.monitoring.arn
        weight = 100
      }

      stickiness {
        enabled  = true
        duration = 600
      }
    }
  }

 condition {
    path_pattern {
      values = ["/grafana"]
    }
  }
}

resource "aws_lb_listener_rule" "logging_rule" {
  listener_arn = aws_lb_listener.logging.arn
  priority     = 100

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.loging.arn
        weight = 100
      }

      stickiness {
        enabled  = true
        duration = 600
      }
    }
  }

 condition {
    path_pattern {
      values = ["/kibana "]
    }
  }
}
