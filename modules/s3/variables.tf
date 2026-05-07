variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string
}

variable "force_destroy" {
  description = "Allow Terraform to delete a non-empty bucket. Use only in dev."
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable S3 object versioning."
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN for SSE-KMS encryption. Falls back to SSE-S3 when null."
  type        = string
  default     = null
}

variable "enable_lifecycle" {
  description = "Enable lifecycle policy for noncurrent version expiration."
  type        = bool
  default     = true
}

variable "noncurrent_version_expiration_days" {
  description = "Days before noncurrent object versions are deleted."
  type        = number
  default     = 90
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
