resource "aws_security_group" "monitoring" {
  name="Monitoring_Bravo"
  description="Monitoring and logging"
  vpc_id=var.vpc_id
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
    cidr_blocks = ["93.170.116.0/24"]
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
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags={
    Name="monitoring_scgroup"
  }
}

/*data "aws_subnet_ids" "private"{
  vpc_id=var.vpc_id
  tags = {
    Tier = "Private"
  }
}
*/

resource "aws_instance" "ec2_instance_monitoring" {
    #for_each = data.aws_subnet_ids.private.ids
    ami=var.ami
    instance_type=var.instance_type
    #key_name="${aws_key_pair.ssh.id}"
    vpc_security_group_ids=["${aws_security_group.monitoring.id}"]
    subnet_id=var.subnet_id
    monitoring=true
    user_data=file("${path.module}/prometheu.sh")

    tags={
        Name="prometheus-server"
    }
}

resource "aws_instance" "ec2_instance_logging" {
    #for_each = data.aws_subnet_ids.private.ids
    ami=var.ami
    instance_type=var.instance_type
    #key_name="${aws_key_pair.ssh.id}"
    vpc_security_group_ids=["${aws_security_group.monitoring.id}"]
    ubnet_id=var.subnet_id
    monitoring=true
    user_data=file("${path.module}/elasticsearch.sh")

    tags={
        Name="elk-stack"
    }
}
