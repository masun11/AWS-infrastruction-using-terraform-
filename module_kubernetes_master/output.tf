output "Public_Ip" {
  value = aws_instance.kubernetes_master.public_ip
}
output "Private_Ip" {
  value = aws_instance.kubernetes_master.private_ip
}
