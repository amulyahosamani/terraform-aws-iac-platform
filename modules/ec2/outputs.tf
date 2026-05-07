output "instance_id" {
  description = "The EC2 instance ID."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP address of the EC2 instance."
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "Public IP (if associated)."
  value       = aws_instance.this.public_ip
}

output "security_group_id" {
  description = "Security group ID attached to the instance."
  value       = aws_security_group.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance."
  value       = aws_instance.this.arn
}
