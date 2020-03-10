resource "aws_vpc" "demo" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = var.public-subnet-cidr

  tags = {
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
}

resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.demo.id
  cidr_block = var.private-subnet-cidr

  tags = {
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }
}

resource "aws_internet_gateway" "igw" { # vs egress only internet gateway
  vpc_id = aws_vpc.demo.id
}

# add route for main route table(internet access for public subnet)
resource "aws_route" "main" {
  route_table_id         = aws_vpc.demo.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_eip" "ngw" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public.id

  depends_on = [aws_internet_gateway.igw]
}

# add route for custom route table(internet access for private subnet)
resource "aws_route_table" "custom" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
}

resource "aws_route_table_association" "custom" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.custom.id
}
