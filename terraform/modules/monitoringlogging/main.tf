module "monitoring_loging"{
    source = "./modules/monitoringloging"
    #version = "0.1"

    ssh_key_pair = var.ssh_key_pair
    vpc_id=var.vpc_id
    subnet=var.subnet
    security_group=var.security_group

    cluster_name="monitoring-loging"
    instance_count=2
    ami="ami-0767046d1677be5a0"
    instance_type="t2.medium"
    min_size=2
    max_size=4
    security_group_rules= [
    {
      type        = "egress"
      from_port   = 0
      to_port     = 65535
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["93.170.116.127"]
    },
    {
      type        = "ingress"
      from_port   = 3000
      to_port     = 3000
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 5044
      to_port     = 5044
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 5601
      to_port     = 5601
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 9090
      to_port     = 9090
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 9100
      to_port     = 9100
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 9200
      to_port     = 9200
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      from_port   = 9093
      to_port     = 9093
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
  ]

}