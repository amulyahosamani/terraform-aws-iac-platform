variable "name_prefix" {
  description = "Prefix used to name all EC2 resources (e.g. 'dev-app')."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the EC2 instance and security group are deployed."
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance."
  type        = string
}

variable "ami_id" {
  description = "AMI ID to launch (e.g. Amazon Linux 2023)."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 key pair (optional, prefer SSM Session Manager)."
  type        = string
  default     = null
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile to attach (scoped per-service)."
  type        = string
}

variable "user_data" {
  description = "Optional user-data bootstrap script."
  type        = string
  default     = null
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP. Default false (private subnet)."
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 20
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
