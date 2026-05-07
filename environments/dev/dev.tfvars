###############################################################################
# DEV environment parameters
# Mirrors the schema of staging.tfvars — only VALUES change between envs.
# This is what delivers zero configuration drift.
###############################################################################

aws_region  = "us-east-1"
environment = "dev"
project     = "iac-platform"
owner       = "platform-team"

# Networking (replace with real IDs from your AWS account)
vpc_id    = "vpc-0aaaaaaaaaaaaaaaa"
subnet_id = "subnet-0aaaaaaaaaaaaaaaa"

# Compute
ami_id        = "ami-0c02fb55956c7d316" # Amazon Linux 2023 (us-east-1)
instance_type = "t3.micro"

ingress_rules = [
  {
    description = "Internal HTTP from VPC CIDR only"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
]
