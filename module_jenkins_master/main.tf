locals {
  ingress_rules = [{
    port        = 22
    description = "Ingress rules for SSH"
    }, {
    port        = 8080
    description = "Ingree rules for Jenkins"
    }, {
    port        = 9100
    description = "Ingress rule for node_exporter"
  }]
}

# Security Groups

resource "aws_security_group" "jenkins_master_sg" {
  name        = "jenkins_master_sg"
  description = "Allow inbound traffic"
  vpc_id      = var.shared_data.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "jenkins_master_sg"
  }
}

# Create Instance

resource "aws_instance" "jenkins_master" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.shared_data.subnet_id
  private_ip                  = var.shared_data.private_ips["jenkins_master"]
  vpc_security_group_ids      = [aws_security_group.jenkins_master_sg.id]
  key_name                    = var.shared_data.keypair

  tags = {
    Name = "jenkins_master"
  }

  user_data = templatefile("${path.module}/install.sh.tpl", {
    node_exporter_sh = file("${path.root}/scripts/install-nodeExporter.sh")
    setup-jenkins    = file("${path.root}/scripts/install-jenkins.sh")
    # setup-ansible-user = templatefile(
    #   "${path.root}/scripts/setup-ansible-user.sh.tpl", {
    #     ansibleadmin_pass = var.ansibleadmin_pass
    # })
  })

}
