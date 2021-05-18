output "DBpass" {
  value = aws_db_instance.postgresql.password
}

output "DB_adress" {
  value = aws_db_instance.postgresql.address
  description = "Private ip of db"
}
