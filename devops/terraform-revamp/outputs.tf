output "bastion-eip" {
  value = aws_eip.bastion.public_ip
}

output "database-private-ip" {
  value = aws_instance.database.*.private_ip
}

output "kubeconfig" {
  value = local.kubeconfig
}

output "config-map-aws-auth" {
  value = local.config_map_aws_auth
}

output "lb-dns-name" {
  value = aws_lb.demo.dns_name
}

output "efs-dns-name" {
  value = aws_efs_file_system.demo.dns_name
}