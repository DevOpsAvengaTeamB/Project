# Define the security group for rds
resource "aws_security_group" "For_RDS"{
 name = "For RDS"
 description = "Allow traffic from Backend"
 ingress {
 from_port = 5432
 to_port = 5432
 protocol = "tcp"
 cidr_blocks = ["${aws_instance.Backend.private_ip}/32"]
 }

 vpc_id = var.vpc-id
 tags ={
 Name = "Postgresql sg" 
 }
}

#RDS
resource "random_password" "password" {
  length           = 8
  special          = true
  override_special = "_%"
}

resource "aws_db_subnet_group" "DB_subnet" {
  subnet_ids = [aws_subnet.subnet-priv-a.id, aws_subnet.subnet-priv-b.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "postgresql" {
    identifier = "backenddb-1"
    allocated_storage = 20
    engine = "postgres"
    engine_version = "12.5"
    instance_class = "db.t2.micro"
    name = "BackendDB"
    username = "Bravo"
    password = random_password.password.result
    port = "5432"
    vpc_security_group_ids = [aws_security_group.For_RDS.id]
    storage_type = "gp2"
    db_subnet_group_name = aws_db_subnet_group.DB_subnet.name
    backup_retention_period = "3"
    backup_window = "00:00-00:30"
    publicly_accessible = false
}
