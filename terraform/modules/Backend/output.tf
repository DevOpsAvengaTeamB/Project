output "DBpassword" {
  value = aws_db_instance.postgresql.password
}

output "Backend" {
  value = aws_instance.Backend.private_ip
  description = "Private ip of backend"
}

output "DB" {
  value = aws_db_instance.postgresql.address
  description = "Private ip of db"
}

