output "bastion-eip" {
  value = aws_eip.bastion.public_ip
}

output "database-private-ip" {
  value = aws_instance.database.private_ip
}

output "kubeconfig" {
  value = local.kubeconfig
}

output "config-map-aws-auth" {
  value = local.config_map_aws_auth
}