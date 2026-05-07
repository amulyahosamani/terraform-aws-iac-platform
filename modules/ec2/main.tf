###############################################################################
# EC2 Module
# Provisions an EC2 instance with a scoped instance profile and security group.
# Replaces console click-ops with a single, reusable, version-controlled module.
###############################################################################

terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# ----------------------------------------------------------------------------
# Security Group — least-privilege ingress
# ----------------------------------------------------------------------------
resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-sg"
  description = "Security group for ${var.name_prefix} EC2 instance"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    description = "Allow outbound HTTPS to package repos and AWS APIs"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sg"
  })
}

# ----------------------------------------------------------------------------
# EC2 Instance
# ----------------------------------------------------------------------------
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.this.id]
  iam_instance_profile   = var.iam_instance_profile_name
  key_name               = var.key_name
  user_data              = var.user_data

  monitoring                  = true
  associate_public_ip_address = var.associate_public_ip

  metadata_options {
    http_tokens                 = "required" # IMDSv2 enforced
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(var.tags, {
    Name = var.name_prefix
  })

  lifecycle {
    ignore_changes = [ami] # avoid forced replacement on AMI updates
  }
}
