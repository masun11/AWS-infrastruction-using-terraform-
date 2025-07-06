output "Public_Ip" {
  value = aws_instance.jenkins_master.public_ip
}
output "Private_Ip" {
  value = aws_instance.jenkins_master.private_ip
}
