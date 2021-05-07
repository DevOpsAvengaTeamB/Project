resource "aws_security_group" "monitoring" {
  name="Monitoring"
  description="Monitoring and loging"
  vpc_id=var.vpc_id

  ingress {
    description="SHH"
    from_port=22
    to_port=22
    protocol="tcp"
    cidr_blocks=["93.170.116.0/24"]
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

  ingress {
    description="AlertManager"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description="Allow all"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags={
    Name="monitoring_scgroup"
  }
}

resource "aws_instance" "monitoring_loging"{
    ami=var.ami
    instance_type="t2.medium"
    #key_name=""
    #subnet=var.subnet
    security_groups=[aws_security_group.monitoring.id]
  
    tags={
       Name="Prometheus ELB"
    }
}
