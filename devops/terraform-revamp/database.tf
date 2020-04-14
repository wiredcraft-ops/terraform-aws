resource "aws_instance" "database" {
  count = var.database-count

  ami = data.aws_ami.centos.id

  instance_type = var.database-instance-type

  key_name = aws_key_pair.qingfeng.key_name

  subnet_id = aws_subnet.private[count.index].id

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  associate_public_ip_address = false

  tags = {
    Name = "db"
  }
}