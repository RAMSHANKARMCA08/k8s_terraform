variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 20.04 or similar"
}

variable "master_instance_type" {
  default = "t2.medium"
}

variable "worker_instance_type" {
  default = "t2.micro"
}

variable "worker_count" {
  default = 2
}

variable "public_key_path" {
  description = "Path to your SSH public key"
}

variable "key_name" {
  description = "EC2 Key pair name"
}