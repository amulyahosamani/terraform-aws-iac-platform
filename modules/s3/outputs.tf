output "bucket_id" {
  description = "Bucket name (id)."
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "Bucket ARN — use this to scope IAM policies."
  value       = aws_s3_bucket.this.arn
}

output "bucket_domain_name" {
  description = "Regional domain name of the bucket."
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
