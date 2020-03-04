resource "aws_instance" "bastion" {
  ami           = data.aws_ami.bastion.id
  instance_type = "c5.large" # TODO: fetch from data

  key_name = aws_key_pair.qingfeng.key_name

  subnet_id = aws_subnet.public.id

  root_block_device {
    volume_type = "gp2"
    volume_size = 20
  }

  associate_public_ip_address = true
}
