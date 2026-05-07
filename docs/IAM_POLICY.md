# IAM Policy Design — Least Privilege, Zero Wildcards

## 🎯 Goal
Eliminate the over-permissioned roles that are common when AWS IAM is built through the console (e.g. `AmazonS3FullAccess` attached to every workload).

## ✅ Rules Enforced

| Rule | Where | How |
|---|---|---|
| No `"Action": "*"` | `modules/iam/main.tf` | Every statement lists explicit actions |
| No `"Resource": "*"` | `modules/iam/variables.tf` | Validation block rejects `*` in `s3_bucket_arns` |
| One role per service | `environments/<env>/main.tf` | Each workload calls the `iam` module separately |
| Scoped log group | `modules/iam/main.tf` | `cloudwatch_log_group_arn` is required, never `*` |
| IMDSv2 enforced | `modules/ec2/main.tf` | `http_tokens = "required"` |

## 📜 Example Policy Generated

For an EC2 service with bucket `arn:aws:s3:::iac-platform-dev-app-data`:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BucketLevelRead",
      "Effect": "Allow",
      "Action": ["s3:GetBucketLocation", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::iac-platform-dev-app-data"]
    },
    {
      "Sid": "ObjectLevelReadWrite",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:GetObjectVersion"
      ],
      "Resource": ["arn:aws:s3:::iac-platform-dev-app-data/*"]
    }
  ]
}
```

Note: **no `*` actions, no `*` resources.** Every ARN is explicit.

## ❌ Anti-Patterns Removed
- ~~`AmazonS3FullAccess`~~ — replaced with bucket-scoped inline policy
- ~~`AdministratorAccess` on EC2~~ — replaced with workload-specific role
- ~~Shared role across services~~ — each service has its own
- ~~SSH key + open port 22~~ — replaced with SSM Session Manager
