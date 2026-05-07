###############################################################################
# DEV Environment Composition
#
# Wires the reusable modules (s3 + iam + ec2) together using ONLY values
# read from dev.tfvars. The same root configuration shape is mirrored in
# environments/staging — this is what guarantees zero configuration drift.
###############################################################################

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote state — values supplied via backend.hcl at `terraform init`.
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = local.common_tags
  }
}

# ----------------------------------------------------------------------------
# Locals — single source of truth for tags & naming
# ----------------------------------------------------------------------------
locals {
  common_tags = {
    Environment = var.environment
    Owner       = var.owner
    Project     = var.project
    ManagedBy   = "Terraform"
  }

  name_prefix = "${var.project}-${var.environment}"
}

# ----------------------------------------------------------------------------
# S3 — application data bucket
# ----------------------------------------------------------------------------
module "app_bucket" {
  source = "../../modules/s3"

  bucket_name        = "${local.name_prefix}-app-data"
  versioning_enabled = true
  enable_lifecycle   = true
  force_destroy      = true # dev only — never set true in prod
  tags               = local.common_tags
}

# ----------------------------------------------------------------------------
# IAM — scoped per-service role (only the bucket above)
# ----------------------------------------------------------------------------
module "app_iam" {
  source = "../../modules/iam"

  role_name      = "${local.name_prefix}-app"
  s3_bucket_arns = [module.app_bucket.bucket_arn] # ← scoped, no wildcards
  enable_ssm     = true
  tags           = local.common_tags
}

# ----------------------------------------------------------------------------
# EC2 — application instance with the scoped IAM profile attached
# ----------------------------------------------------------------------------
module "app_ec2" {
  source = "../../modules/ec2"

  name_prefix               = "${local.name_prefix}-app"
  vpc_id                    = var.vpc_id
  subnet_id                 = var.subnet_id
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  iam_instance_profile_name = module.app_iam.instance_profile_name
  associate_public_ip       = false
  root_volume_size          = 20
  ingress_rules             = var.ingress_rules
  tags                      = local.common_tags
}
