resource "aws_security_group" "monitoring" {
  name="Monitoring_Bravo"
  description="Monitoring and logging"
  vpc_id=var.vpc-id
  ingress {
    protocol  = "-1"
    self      = true
    from_port = 0
    to_port   = 0
  }

  ingress {
    description = "SHH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/16"]
  }

  ingress {
    description="Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description="Beats(Filebeat)"
    from_port   = 5044
    to_port     = 5044
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

  ingress {
    description="Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description="Node exporter (prometheus)"
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description="Elasticsearch JSON"
    from_port   = 9200
    to_port     = 9200
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
    Name="monitoring_scgroup"
  }
}


resource "aws_instance" "ec2_instance_monitoring" {
    ami=var.ami
    instance_type=var.instance_type
    key_name="key"
    vpc_security_group_ids=["${aws_security_group.monitoring.id}"]
    subnet_id=var.subnet-priv-a-id
    monitoring=true
    #user_data=file("${path.module}/prometheu.sh")
    user_data = templatefile("./modules/monitoring/prometheu.sh.tpl", {aws_alb_dns = var.aws_alb_dns})

    tags={
        Name="prometheus-server-teamB"
    }
}

resource "aws_instance" "ec2_instance_logging" {
    ami=var.ami
    instance_type=var.instance_type
    key_name="key"
    vpc_security_group_ids=["${aws_security_group.monitoring.id}"]
    subnet_id=var.subnet-priv-a-id
    monitoring=true
    #user_data=file("${path.module}/elasticsearch.sh")
    user_data = templatefile("./modules/monitoring/elasticsearch.sh.tpl", {aws_alb_dns = var.aws_alb_dns})

    tags={
        Name="elk-stack-teamB"
    }
}

resource "aws_security_group" "loadbalancer" {
  name="Loadbalancer_Bravo"
  description="Grafana and Kibana"
  vpc_id=var.vpc-id
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


resource "aws_lb_target_group" "monitoring" {
  name     = "monitoring-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  tags={
        Name="monitoring-tg-teamB"
    }
}
resource "aws_lb_target_group_attachment" "monitoring" {
  target_group_arn = aws_lb_target_group.monitoring.arn
  target_id        = aws_instance.ec2_instance_monitoring.id
}

resource "aws_lb_target_group" "logging" {
  name     = "loging-tg"
  port     = 5601
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  tags={
        Name="loging-tg-teamB"
    }
}

resource "aws_lb_target_group_attachment" "logging" {
  target_group_arn = aws_lb_target_group.logging.arn
  target_id        = aws_instance.ec2_instance_logging.id
}

resource "aws_lb_listener_rule" "monitiring_rule" {
  listener_arn = var.aws_alb_listener-arn
  priority     = 3
    action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.logging.arn
  }
  condition {
    path_pattern {
      values = ["/grafana"]
    }
  }  
}



resource "aws_lb_listener_rule" "logging_rule" {
  listener_arn = var.aws_alb_listener-arn
  priority     = 2
    action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.logging.arn
  }
  condition {
    path_pattern {
      values = ["/kibana"]
    }
  }  
}