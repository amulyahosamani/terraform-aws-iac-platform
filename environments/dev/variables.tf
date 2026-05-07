variable "aws_region" {
  description = "AWS region for the dev environment."
  type        = string
}

variable "environment" {
  description = "Environment name (dev / staging / prod)."
  type        = string
}

variable "project" {
  description = "Project / workload name used for naming and tagging."
  type        = string
}

variable "owner" {
  description = "Owning team or individual."
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID."
  type        = string
}

variable "subnet_id" {
  description = "Existing subnet ID for the EC2 instance."
  type        = string
}

variable "ami_id" {
  description = "AMI to launch (e.g. Amazon Linux 2023)."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "ingress_rules" {
  description = "Security group ingress rules."
  type = list(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}
