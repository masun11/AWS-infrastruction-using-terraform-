locals {
  ingress_rules = [{
    from_port   = 22
    to_port     = 22
    description = "Ingress rules for SSH"
    }, {
    from_port   = 10250
    to_port     = 10250
    description = "Ingress rule for kubelet API"
    }, {
    from_port   = 30000
    to_port     = 32767
    description = "Ingress rule for Kubernetes NodePort services"
    }, {
    from_port   = 9100
    to_port     = 9100
    description = "Ingress rule for node_exporter"
  }]
}

# Security Groups

resource "aws_security_group" "kubernetes_slave_sg" {
  name        = "kubernetes_slave_sg"
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
    Name = "kubernetes_slave_sg"
  }
}

# Create Instance

resource "aws_instance" "kubernetes_slave" {
  count                       = 2
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  associate_public_ip_address = true
  subnet_id                   = var.shared_data.subnet_id
  private_ip                  = var.shared_data.private_ips.worker_nodes[count.index]
  vpc_security_group_ids      = [aws_security_group.kubernetes_slave_sg.id]
  key_name                    = var.shared_data.keypair

  tags = {
    Name = "kubernetes_slave${count.index}"
  }

  user_data = templatefile("${path.module}/install.sh.tpl", {
    node_exporter_sh   = file("${path.root}/scripts/install-nodeExporter.sh")
    install-kubernetes = file("${path.root}/scripts/install-kubernetes.sh")
    index              = count.index
    kubernetes_ip      = var.shared_data.private_ips["kubernetes_master"]
  })

}
