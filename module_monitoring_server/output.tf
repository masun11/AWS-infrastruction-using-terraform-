output "Public_Ip" {
  value = aws_instance.monitoring_server.public_ip
}
output "Private_Ip" {
  value = aws_instance.monitoring_server.private_ip
}
