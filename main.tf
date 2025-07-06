provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}


# Create VPC

resource "aws_vpc" "project1vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "project1vpc"
  }
}

# Create Subnet 

resource "aws_subnet" "project1subnet" {
  vpc_id            = aws_vpc.project1vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "project1subnet"
  }
}

# Internet Gateway

resource "aws_internet_gateway" "project1gw" {
  vpc_id = aws_vpc.project1vpc.id

  tags = {
    Name = "project1gw"
  }
}

# Route Table

resource "aws_route_table" "project1rt" {
  vpc_id = aws_vpc.project1vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.project1gw.id
  }

  tags = {
    Name = "project1rt"
  }
}

# Route Table Association

resource "aws_route_table_association" "project1rta" {
  subnet_id      = aws_subnet.project1subnet.id
  route_table_id = aws_route_table.project1rt.id
}


#################################
############ Modules ############
locals {
  shared_data = {
    vpc_id      = aws_vpc.project1vpc.id
    subnet_id   = aws_subnet.project1subnet.id
    private_ips = var.private_ips
    keypair     = var.keypair
  }
}

module "monitoring_server" {
  source      = "./module_monitoring_server"
  shared_data = local.shared_data
}

module "jenkins_master" {
  source      = "./module_jenkins_master"
  shared_data = local.shared_data
}

module "build_server" {
  source      = "./module_build_server"
  shared_data = local.shared_data
}

module "kubernetes_master" {
  source      = "./module_kubernetes_master"
  shared_data = local.shared_data
}

module "kubernetes_slaves" {
  source      = "./module_kubernetes_slaves"
  shared_data = local.shared_data
}
