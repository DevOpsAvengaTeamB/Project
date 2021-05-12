variable "vpc-name" {
  description = "VPC"
  default     = "vpc"
  type        = string
}

variable "vpc-cidr" {
  description = "VPC CIDR"
  default     = "192.168.0.0/16"
  type        = string
}

# [0] - for subnet-public-A
# [1] - for subnet-private-A
variable "subnet-a-name" {
  description = "Subnet names A-B"
  type        = list(string)
  default = [
    "subnet-public-A",
    "subnet-private-A",
  ]
}

variable "subnet-b-name" {
  description = "Subnet names A-B"
  type        = list(string)
  default = [
    "subnet-public-B",
    "subnet-private-B",
  ]
}

variable "igw-name" {
  description = "Internet gateway name"
  default     = "IGW"
  type        = string
}

variable "nat-eip" {
  description = "Elastic IP address for NAT gateway"
  type        = string
  default     = "eip-nat"
}

variable "nat-name" {
  description = "NAT gateway name"
  default     = "NAT"
  type        = string
}

variable "routetable-name" {
  description = "Route table names list"
  type        = list(string)
  default = [
    "public-route-table",
    "private-route-table",
  ]
}

variable "all-ip" {
  description = "Allowed all IP"
  type        = string
  default     = "0.0.0.0/0"
}
