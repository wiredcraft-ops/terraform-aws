# allow ssh from WCL office
resource "aws_security_group_rule" "allow-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.wcl-ips
  security_group_id = aws_vpc.demo.default_security_group_id
}

# eks
resource "aws_security_group" "demo-eks" {
  name        = "tf-demo-eks"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.demo.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-demo-eks"
  }
}