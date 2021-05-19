output "db_pass" {
  value = aws_db_instance.postgresql.password
}

output "db_url" {
  value = aws_db_instance.postgresql.address
  description = "Private ip of db"
}
output "rds" {
  value = aws_db_instance.postgresql.address
  description = "Private ip of db"
}
