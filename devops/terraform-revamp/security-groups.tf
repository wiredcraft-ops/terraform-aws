# allow ssh connection from WCL office
resource "aws_security_group_rule" "allow-ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = var.wcl-ips
  security_group_id = aws_vpc.demo.default_security_group_id
}