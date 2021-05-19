# CREATE VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.vpc-name}"
  }
}
# CREATE SUBNETS
# List available availability zone names
data "aws_availability_zones" "available" {
  state = "available"
}
# subnets for availability zone eu-west-a
resource "aws_subnet" "subnet-public-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, 1)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.subnet-a-name[0]}"
  }
}
resource "aws_subnet" "subnet-private-a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, 2)
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.subnet-a-name[1]}"
  }
}

# subnets for availability zone eu-west-3b
resource "aws_subnet" "subnet-public-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, 4)
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.subnet-b-name[0]}"
  }
}
resource "aws_subnet" "subnet-private-b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.vpc-cidr, 8, 5)
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = "false"
  tags = {
    Name = "${var.subnet-b-name[1]}"
  }
}

# CREATE GATEWAYS
# elastic IP allocation
resource "aws_eip" "eip-nat" {
  tags = {
    Name = "${var.nat-eip}"
  }
}
# internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.igw-name}"
  }
}
# NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip-nat.id
  subnet_id     = aws_subnet.subnet-public-a.id
  depends_on    = [ aws_internet_gateway.igw ]
  tags = {
    Name = "${var.nat-name}"
  }
}
# CREATE ROUTING
# create route tables for public, private and database subnets
resource "aws_route_table" "routetable-public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.routetable-name[0]}"
  }
}
resource "aws_route_table" "routetable-private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.routetable-name[1]}"
  }
}

# create routing rules for public and private subnets
resource "aws_route" "public-route" {
  route_table_id         = aws_route_table.routetable-public.id
  destination_cidr_block = var.all-ip
  gateway_id             = aws_internet_gateway.igw.id
}
resource "aws_route" "private-route" {
  route_table_id         = aws_route_table.routetable-private.id
  destination_cidr_block = var.all-ip
  nat_gateway_id         = aws_nat_gateway.nat.id
}
# associate route tables with subnets in A-B
resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.subnet-public-a.id
  route_table_id = aws_route_table.routetable-public.id
}
resource "aws_route_table_association" "private-subnet-association" {
  subnet_id      = aws_subnet.subnet-private-a.id
  route_table_id = aws_route_table.routetable-private.id
}
# associate route tables with subnets in A-B
resource "aws_route_table_association" "public-subnet-association-b" {
  subnet_id      = aws_subnet.subnet-public-b.id
  route_table_id = aws_route_table.routetable-public.id
}
resource "aws_route_table_association" "private-subnet-association-b" {
  subnet_id      = aws_subnet.subnet-private-b.id
  route_table_id = aws_route_table.routetable-private.id
}

# VPC's main routing table fallback
resource "aws_main_route_table_association" "set-main-routetable" {
  vpc_id         = aws_vpc.vpc.id
  route_table_id = aws_route_table.routetable-public.id
}
