resource "aws_instance" "bastion" {
  ami           = data.aws_ami.centos.id
  instance_type = "c5.large" # TODO: fetch from data

  key_name = aws_key_pair.qingfeng.key_name

  subnet_id = aws_subnet.public-1.id

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }
}

resource "aws_eip" "bastion" {
  vpc = true
}

resource "aws_eip_association" "bastion" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion.id
}
