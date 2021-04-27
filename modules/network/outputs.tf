output "vpc-id" {
  description = "The ID of the VPC"
  value       = "${aws_vpc.vpc.id}"
}
output "availability-zone-a" {
  value = "${data.aws_availability_zones.available.names[0]}"
}
output "availability-zone-b" {
  value = "${data.aws_availability_zones.available.names[1]}"
}
output "subnet-pub-a-id" {
  description = "The ID of public subnet in A-B"
  value       = "${aws_subnet.subnet-public-a.id}"
}
output "subnet-pub-b-id" {
  description = "The ID of public subnet in A-B"
  value       = "${aws_subnet.subnet-public-b.id}"
}
output "subnet-priv-a-id" {
  description = "The ID of public subnet in A-B"
  value       = "${aws_subnet.subnet-private-a.id}"
}
output "subnet-priv-b-id" {
  description = "The ID of public subnet in A-B"
  value       = "${aws_subnet.subnet-private-b.id}"
}
output "all-ip" {
  description = "CIDR block 0.0.0.0/0"
  value       = "${var.all-ips}"
}
