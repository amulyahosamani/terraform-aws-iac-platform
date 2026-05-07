###############################################################################
# STAGING Environment Composition
#
# Identical structure to environments/dev — proving the multi-env design.
# All differences live in staging.tfvars, not in code.
###############################################################################

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

locals {
  common_tags = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.project
    ManagedBy   = "Terraform"
  }

  name_prefix = "${var.project}-${var.environment}"
}

module "app_bucket" {
  source = "../../modules/s3"

  bucket_name        = "${local.name_prefix}-app-data"
  versioning_enabled = true
  enable_lifecycle   = true
  force_destroy      = false # staging keeps data
  tags               = local.common_tags
}

module "app_iam" {
  source = "../../modules/iam"

  role_name      = "${local.name_prefix}-app"
  s3_bucket_arns = [module.app_bucket.bucket_arn]
  enable_ssm     = true
  tags           = local.common_tags
}

module "app_ec2" {
  source = "../../modules/ec2"

  name_prefix               = "${local.name_prefix}-app"
  vpc_id                    = var.vpc_id
  subnet_id                 = var.subnet_id
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  iam_instance_profile_name = module.app_iam.instance_profile_name
  associate_public_ip       = false
  root_volume_size          = 30
  ingress_rules             = var.ingress_rules
  tags                      = local.common_tags
}
