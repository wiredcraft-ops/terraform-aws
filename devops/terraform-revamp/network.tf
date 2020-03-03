resource "aws_vpc" "demo" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.demo
  cidr_block = var.public-subnet-cidr
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.demo
  cidr_block = var.private-subnet-cidr
}