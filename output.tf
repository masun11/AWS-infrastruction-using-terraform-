output "MONITORING_SERVER_INFO" {
  value = <<EOT
####################################################
📊 Monitoring Server
----------------------------------------------------
🔹 Public IP : ${module.monitoring_server.Public_Ip}
🔹 Private IP: ${module.monitoring_server.Private_Ip}
####################################################
EOT
}


output "JENKINS_MASTER_INFO" {
  value = <<EOT
####################################################
🚀 Jenkins Master Server
----------------------------------------------------
🔹 Public IP : ${module.jenkins_master.Public_Ip}
🔹 Private IP: ${module.jenkins_master.Private_Ip}
####################################################
EOT
}

output "JENKINS_BUILD_SERVER_INFO" {
  value = <<EOT
####################################################
🛠️ Jenkins Build Server
----------------------------------------------------
🔹 Public IP : ${module.build_server.Public_Ip}
🔹 Private IP: ${module.build_server.Private_Ip}
####################################################
EOT
}

output "KUBERNETES_MASTER_INFO" {
  value = <<EOT
####################################################
🧠 Kubernetes Master Server
----------------------------------------------------
🔹 Public IP : ${module.kubernetes_master.Public_Ip}
🔹 Private IP: ${module.kubernetes_master.Private_Ip}
####################################################
EOT
}

output "KUBERNETES_SLAVES_INFO" {
  value = <<EOT
####################################################
🧱 Kubernetes Slave Servers
----------------------------------------------------
🔹 Public IP : [${join(", ", module.kubernetes_slaves.Public_Ips)}]
🔹 Private IP: [${join(", ", module.kubernetes_slaves.Private_Ips)}]
####################################################
EOT
}

