output "bastion-public-ip" {
  value = aws_instance.bastion.public_ip
}

output "database-private-ip" {
  value = aws_instance.database.private_ip
}