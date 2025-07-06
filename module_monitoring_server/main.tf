locals {
  ingress_rules = [{
    from_port   = 22
    to_port     = 22
    description = "Ingress rules for SSH"
    }, {
    from_port   = 9090
    to_port     = 9090
    description = "Ingress rule for Prometheus"
    }, {
    from_port   = 3000
    to_port     = 3000
    description = "Ingress rule for Garfana"
  }]
}

# Security Groups

resource "aws_security_group" "monitoring_server_sg" {
  name        = "monitoring_server_sg"
  description = "Allow inbound traffic"
  vpc_id      = var.shared_data.vpc_id

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
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
    Name = "monitoring_server_sg"
  }
}

# Create Instance

resource "aws_instance" "monitoring_server" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.shared_data.subnet_id
  private_ip                  = var.shared_data.private_ips["monitor_server"]
  vpc_security_group_ids      = [aws_security_group.monitoring_server_sg.id]
  key_name                    = var.shared_data.keypair

  tags = {
    Name = "monitoring_server"
  }

  user_data = templatefile("${path.module}/install.sh.tpl", {
    prometheus = templatefile(
      "${path.root}/scripts/install-prometheus.sh.tpl",
      {
        private_ips = var.shared_data.private_ips
      }
    )
    grafana = file("${path.root}/scripts/install-grafana.sh")
  })

}
