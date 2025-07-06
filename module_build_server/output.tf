output "Public_Ip" {
  value = aws_instance.build_server.public_ip
}
output "Private_Ip" {
  value = aws_instance.build_server.private_ip
}
