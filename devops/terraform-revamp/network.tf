resource "aws_vpc" "demo" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = var.public-subnet-cidr
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = var.private-subnet-cidr
}

resource "aws_internet_gateway" "igw" { # vs egress only internet gateway
  vpc_id = aws_vpc.demo.id
}

# update route table
resource "aws_route" "internet" {
  route_table_id         = aws_vpc.demo.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}