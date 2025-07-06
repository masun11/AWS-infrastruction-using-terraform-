
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}
variable "access_key" {
  description = "User Masun's access key"
  type        = string
  default     = "xxxxxxxxxxxxxxxxxxxx"
}
variable "secret_key" {
  description = "User Masun's secret key"
  type        = string
  default     = "xxxxxxxxxxxxxxxxxxxx"
}
variable "availability_zone" {
  description = "Subnet's Availability Zone"
  type        = string
  default     = "ap-south-1a"
}
variable "keypair" {
  description = "AWS keypair name"
  type        = string
  default     = "masun-awskey"
}

/**
 * A map of private IP addresses assigned to different server roles.
 *
 * This includes:
 * - monitor_server:     Prometheus/Grafana monitoring server
 * - jenkins_master:     Jenkins CI/CD master node
 * - build_server:       Dedicated server for build tasks
 * - kubernetes_master:  Kubernetes control plane node
 * - worker_nodes:       A list of private IPs for Kubernetes worker nodes
 *
 * These IPs must be within the same VPC subnet CIDR block and not overlap with other instances.
 * Ensure that the number of worker node IPs matches the count of worker node instances.
 * var.private_ips["jenkins_master"]
 * var.private_ips.worker_nodes[count.index]
 */
variable "private_ips" {
  description = "A map of private IP addresses assigned to different server roles"
  type        = any
  default = {
    monitor_server    = "10.0.1.10"
    jenkins_master    = "10.0.1.11"
    build_server      = "10.0.1.12"
    kubernetes_master = "10.0.1.13"
    worker_nodes      = ["10.0.1.14", "10.0.1.15"]
  }
}
