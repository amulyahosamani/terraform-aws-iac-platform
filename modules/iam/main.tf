###############################################################################
# IAM Module — Least-Privilege Service Roles
#
# Design rules (enforced):
#   1. NO  "Action":   "*"
#   2. NO  "Resource": "*"   (except where AWS API requires it, e.g. ec2:Describe*)
#   3. Each service gets its OWN role, scoped to ONLY the bucket ARNs it owns.
#
# This is the antithesis of the over-permissioned roles commonly created by
# clicking through the AWS Console.
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
# Trust policy — only EC2 may assume this role
# ----------------------------------------------------------------------------
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.role_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  description        = "Service role for ${var.role_name} — scoped, no wildcards."
  tags               = var.tags
}

# ----------------------------------------------------------------------------
# Scoped S3 access — ONLY the buckets passed in via var.s3_bucket_arns
# ----------------------------------------------------------------------------
data "aws_iam_policy_document" "s3_scoped" {
  count = length(var.s3_bucket_arns) > 0 ? 1 : 0

  # Bucket-level operations
  statement {
    sid    = "BucketLevelRead"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
    ]
    resources = var.s3_bucket_arns
  }

  # Object-level operations — scoped to /* under each bucket
  statement {
    sid    = "ObjectLevelReadWrite"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObjectVersion",
    ]
    resources = [for arn in var.s3_bucket_arns : "${arn}/*"]
  }
}

resource "aws_iam_policy" "s3_scoped" {
  count       = length(var.s3_bucket_arns) > 0 ? 1 : 0
  name        = "${var.role_name}-s3-scoped"
  description = "Scoped S3 access for ${var.role_name} — no wildcards."
  policy      = data.aws_iam_policy_document.s3_scoped[0].json
}

resource "aws_iam_role_policy_attachment" "s3_scoped" {
  count      = length(var.s3_bucket_arns) > 0 ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.s3_scoped[0].arn
}

# ----------------------------------------------------------------------------
# SSM Session Manager — managed policy (AWS-vetted, narrowly scoped)
# Lets ops connect without SSH keys or open port 22.
# ----------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.enable_ssm ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# ----------------------------------------------------------------------------
# CloudWatch logs — scoped to a specific log group ARN (no wildcards)
# ----------------------------------------------------------------------------
data "aws_iam_policy_document" "logs_scoped" {
  count = var.cloudwatch_log_group_arn != null ? 1 : 0

  statement {
    sid    = "ScopedLogWrites"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      var.cloudwatch_log_group_arn,
      "${var.cloudwatch_log_group_arn}:*",
    ]
  }
}

resource "aws_iam_policy" "logs_scoped" {
  count       = var.cloudwatch_log_group_arn != null ? 1 : 0
  name        = "${var.role_name}-logs-scoped"
  description = "Scoped CloudWatch Logs writes for ${var.role_name}."
  policy      = data.aws_iam_policy_document.logs_scoped[0].json
}

resource "aws_iam_role_policy_attachment" "logs_scoped" {
  count      = var.cloudwatch_log_group_arn != null ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.logs_scoped[0].arn
}

# ----------------------------------------------------------------------------
# Instance profile — wraps the role for EC2 attachment
# ----------------------------------------------------------------------------
resource "aws_iam_instance_profile" "this" {
  name = "${var.role_name}-profile"
  role = aws_iam_role.this.name
  tags = var.tags
}
