variable "shared_data" {
}
variable "instance_ami" {
  description = "Amazon Machine Image of ubuntu:22.04"
  type        = string
  default     = "ami-0f918f7e67a3323f0"
}
variable "instance_type" {
  description = "Jenkins master instance type"
  type        = string
  default     = "t2.medium"
}
# variable "ansibleadmin_pass" {
#   description = "Ansible Worker: ansibleadmin password"
#   type        = string
#   default     = "s0b1ejAb0"
# }
