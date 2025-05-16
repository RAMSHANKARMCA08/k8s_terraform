provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "deployer" {
  key_name   = "k8s-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "k8s_sg" {
  name        = "k8s-sg"
  description = "Allow Kubernetes communication"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
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

resource "aws_instance" "k8s_master" {
  ami           = var.ami_id
  instance_type = var.master_instance_type
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.k8s_sg.name]
  tags = {
    Name = "K8s-Master"
  }

  user_data = file("scripts/master.sh")
}

resource "aws_instance" "k8s_workers" {
  count         = var.worker_count
  ami           = var.ami_id
  instance_type = var.worker_instance_type
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.k8s_sg.name]
  tags = {
    Name = "K8s-Worker-${count.index}"
  }

  user_data = file("scripts/worker.sh")
}
