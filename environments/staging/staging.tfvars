###############################################################################
# STAGING environment parameters
# Same schema as dev.tfvars — only the VALUES differ.
###############################################################################

aws_region  = "us-east-1"
environment = "staging"
project     = "iac-platform"
owner       = "platform-team"

# Networking
vpc_id    = "vpc-0bbbbbbbbbbbbbbbb"
subnet_id = "subnet-0bbbbbbbbbbbbbbbb"

# Compute — staging gets a slightly larger instance
ami_id        = "ami-0c02fb55956c7d316"
instance_type = "t3.small"

ingress_rules = [
  {
    description = "Internal HTTP from VPC CIDR only"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  },
  {
    description = "HTTPS from VPC CIDR only"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.1.0.0/16"]
  }
]
