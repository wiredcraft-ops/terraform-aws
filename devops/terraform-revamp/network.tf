resource "aws_vpc" "demo" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id               = aws_vpc.demo.id
  cidr_block           = var.public-subnet-1-cidr
  availability_zone_id = var.az-1

  tags = {
    Name                                    = "public-1"
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
}

resource "aws_subnet" "public-2" {
  vpc_id               = aws_vpc.demo.id
  cidr_block           = var.public-subnet-2-cidr
  availability_zone_id = var.az-2

  tags = {
    Name                                    = "public-2"
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
}

resource "aws_subnet" "public-3" {
  vpc_id               = aws_vpc.demo.id
  cidr_block           = var.public-subnet-3-cidr
  availability_zone_id = var.az-3

  tags = {
    Name                                    = "public-3"
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
}

resource "aws_subnet" "private-1" {
  vpc_id               = aws_vpc.demo.id
  cidr_block           = var.private-subnet-1-cidr
  availability_zone_id = var.az-1

  tags = {
    Name                                    = "private-1"
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }
}

resource "aws_subnet" "private-2" {
  vpc_id               = aws_vpc.demo.id
  cidr_block           = var.private-subnet-2-cidr
  availability_zone_id = var.az-2

  tags = {
    Name                                    = "private-2"
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }
}

resource "aws_subnet" "private-3" {
  vpc_id               = aws_vpc.demo.id
  cidr_block           = var.private-subnet-3-cidr
  availability_zone_id = var.az-3

  tags = {
    Name                                    = "private-3"
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
    "kubernetes.io/role/internal-elb"       = 1
  }
}

resource "aws_internet_gateway" "igw" { # VS egress only internet gateway
  vpc_id = aws_vpc.demo.id
}

# allow internet access for public subnets
resource "aws_route" "main" {
  route_table_id         = aws_vpc.demo.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_eip" "ngw-1" {
  vpc = true

  tags {
    Name = "ngw-1"
  }
}

resource "aws_nat_gateway" "ngw-1" {
  allocation_id = aws_eip.ngw-1.id
  subnet_id     = aws_subnet.public-1.id

  tags {
    Name = "ngw-1"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "ngw-2" {
  vpc = true

  tags {
    Name = "ngw-2"
  }
}

resource "aws_nat_gateway" "ngw-2" {
  allocation_id = aws_eip.ngw-2.id
  subnet_id     = aws_subnet.public-2.id

  tags {
    Name = "ngw-2"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_eip" "ngw-3" {
  vpc = true

  tags {
    Name = "ngw-3"
  }
}

resource "aws_nat_gateway" "ngw-3" {
  allocation_id = aws_eip.ngw-3.id
  subnet_id     = aws_subnet.public-3.id

  tags {
    Name = "ngw-3"
  }

  depends_on = [aws_internet_gateway.igw]
}

# allow internet access for private subnets
resource "aws_route_table" "custom-1" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-1.id
  }
}
resource "aws_route_table_association" "custom-1" {
  subnet_id      = aws_subnet.private-1.id
  route_table_id = aws_route_table.custom-1.id
}

resource "aws_route_table" "custom-2" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-2.id
  }
}
resource "aws_route_table_association" "custom-2" {
  subnet_id      = aws_subnet.private-2.id
  route_table_id = aws_route_table.custom-2.id
}

resource "aws_route_table" "custom-3" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw-3.id
  }
}
resource "aws_route_table_association" "custom-3" {
  subnet_id      = aws_subnet.private-3.id
  route_table_id = aws_route_table.custom-3.id
}