output "role_arn" {
  description = "ARN of the IAM role."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the IAM role."
  value       = aws_iam_role.this.name
}

output "instance_profile_name" {
  description = "Instance profile name to attach to EC2."
  value       = aws_iam_instance_profile.this.name
}

output "instance_profile_arn" {
  description = "Instance profile ARN."
  value       = aws_iam_instance_profile.this.arn
}
