output "master_ip" {
  value = aws_instance.k8s_master.public_ip
}

output "worker_ips" {
  value = [for instance in aws_instance.k8s_workers : instance.public_ip]
}
