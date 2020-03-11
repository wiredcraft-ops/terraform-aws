# allow ssh from WCL office
resource "aws_security_group_rule" "allow-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.wcl-ips
  security_group_id = aws_vpc.demo.default_security_group_id
}
# allow traffic across VPC
resource "aws_security_group_rule" "allow-from-eks-worker" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = [var.vpc-cidr]
  security_group_id = aws_vpc.demo.default_security_group_id
}

# eks
resource "aws_security_group" "demo-eks" {
  name        = var.eks-name
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.demo.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc-cidr] # allow connect to eks(control panel + worker)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name                                    = var.eks-name
    "kubernetes.io/cluster/${var.eks-name}" = "owned"
  }
}