output "Public_Ips" {
  value = [for instance in aws_instance.kubernetes_slave : instance.public_ip]
}

output "Private_Ips" {
  value = [for instance in aws_instance.kubernetes_slave : instance.private_ip]
}
