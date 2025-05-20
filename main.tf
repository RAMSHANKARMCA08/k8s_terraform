provider "aws" {
  region = var.aws_region
}

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "k8s_sg" {
  name        = "k8s_sg"
  description = "Allow SSH and all traffic between nodes"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    self        = true
  }
  
  # Allow Port 8080 (e.g., for Argo CD, custom app)
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "k8s_sg_id" {
  value = aws_security_group.k8s_sg.id
}

# Master Node
resource "aws_instance" "k8s_master" {
  ami           = var.ami_id
  instance_type = var.master_instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  #security_groups = [aws_security_group.k8s_sg.name]
  
  associate_public_ip_address = true
  tags = {
    Name = "K8s-Master"
  }

  user_data = file("scripts/master.sh")
}

# Worker Node
resource "aws_instance" "k8s_workers" {
  count         = var.worker_count
  ami           = var.ami_id
  instance_type = var.worker_instance_type
  key_name      = var.key_name
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.k8s_sg.id]
  #security_groups = [aws_security_group.k8s_sg.name]
  
  associate_public_ip_address = true  
  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }

  user_data = file("scripts/worker.sh")
}
