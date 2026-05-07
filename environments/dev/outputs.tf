output "bucket_name" {
  description = "Name of the application S3 bucket."
  value       = module.app_bucket.bucket_id
}

output "bucket_arn" {
  description = "ARN of the application S3 bucket."
  value       = module.app_bucket.bucket_arn
}

output "instance_id" {
  description = "EC2 instance ID."
  value       = module.app_ec2.instance_id
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance."
  value       = module.app_ec2.private_ip
}

output "iam_role_arn" {
  description = "Scoped IAM role ARN attached to the instance."
  value       = module.app_iam.role_arn
}
