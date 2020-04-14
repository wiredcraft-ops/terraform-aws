resource "aws_vpc" "demo" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "public" {
  count = var.subnet-count

  vpc_id               = aws_vpc.demo.id
  cidr_block           = local.public-cidrs[count.index]
  availability_zone_id = var.az-names[count.index]

  tags = {
    Name                                    = "public-${count.index}"
    "kubernetes.io/cluster/${var.eks-name}" = "shared"
    "kubernetes.io/role/elb"                = 1
  }
}

resource "aws_subnet" "private" {
  count = var.subnet-count

  vpc_id               = aws_vpc.demo.id
  cidr_block           = local.private-cidrs[count.index]
  availability_zone_id = var.az-names[count.index]

  tags = {
    Name                                    = "private-${count.index}"
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

resource "aws_eip" "ngw" {
  count = var.subnet-count

  vpc = true

  tags = {
    Name = "ngw-${count.index}"
  }
}

resource "aws_nat_gateway" "ngw" {
  count = var.subnet-count

  allocation_id = aws_eip.ngw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "ngw-${count.index}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# allow internet access for private subnets
resource "aws_route_table" "custom" {
  count = var.subnet-count

  vpc_id = aws_vpc.demo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw[count.index].id
  }
}
resource "aws_route_table_association" "custom" {
  count = var.subnet-count

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.custom[count.index].id
}