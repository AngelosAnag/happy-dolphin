output "instance_hostnames" {
  description = "Private DNS names of all EC2 instances"
  value       = [for v in aws_instance.app_server : v.private_dns]
}