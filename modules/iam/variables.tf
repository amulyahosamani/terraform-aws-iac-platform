variable "role_name" {
  description = "Logical name of the role (e.g. 'dev-app'). Used to namespace IAM resources."
  type        = string
}

variable "s3_bucket_arns" {
  description = "Exact bucket ARNs this role may access. NEVER pass '*'."
  type        = list(string)
  default     = []

  validation {
    condition     = !contains(var.s3_bucket_arns, "*")
    error_message = "Wildcard '*' is forbidden. Pass explicit bucket ARNs only."
  }
}

variable "cloudwatch_log_group_arn" {
  description = "Optional CloudWatch log group ARN for scoped log writes."
  type        = string
  default     = null
}

variable "enable_ssm" {
  description = "Attach AmazonSSMManagedInstanceCore for Session Manager access."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
