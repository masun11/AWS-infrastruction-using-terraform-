variable "shared_data" {
}
variable "instance_ami" {
  description = "Amazon Machine Image of ubuntu:22.04"
  type        = string
  default     = "ami-0f918f7e67a3323f0"
}
variable "instance_type" {
  description = "Jenkins build server instance type"
  type        = string
  default     = "t2.micro"
}
variable "devopsadmin_pass" {
  description = "Ansible control: devopsadmin password"
  type        = string
  default     = "0"
}
