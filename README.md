# 🚀 Terraform AWS IaC Platform

> **Production-grade Infrastructure-as-Code platform** that eliminates manual AWS provisioning through reusable Terraform modules, least-privilege IAM, and zero-drift multi-environment deployments.

[![Terraform](https://img.shields.io/badge/Terraform-1.6+-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-EC2%20%7C%20S3%20%7C%20IAM-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![CI](https://img.shields.io/badge/CI-GitHub%20Actions-2088FF?logo=github-actions&logoColor=white)](.github/workflows/terraform.yml)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📌 Project Highlights

| Achievement | Impact |
|---|---|
| 🛠 **Eliminated Click-Ops** | Replaced 100% of manual AWS Console provisioning with version-controlled Terraform modules for EC2 & S3 |
| 🔒 **Zero Wildcard IAM** | Every IAM role is scoped per-service with resource-level ARNs — no `"Action": "*"` or `"Resource": "*"` |
| 🌐 **Multi-Env Parity** | Parameterised `tfvars` across `dev` and `staging` deliver **zero configuration drift** between environments |
| ♻️ **Reusable Modules** | DRY architecture — three composable modules (`ec2`, `s3`, `iam`) reused across environments |
| ✅ **CI-Validated** | GitHub Actions runs `fmt`, `validate`, `tflint`, and `tfsec` on every PR |

---

## 🏗 Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      GitHub Actions CI/CD                        │
│         fmt → validate → tflint → tfsec → plan → apply           │
└────────────────────────────┬────────────────────────────────────┘
                             │
              ┌──────────────┴──────────────┐
              │                             │
        ┌─────▼─────┐                 ┌─────▼─────┐
        │    DEV    │                 │  STAGING  │
        │ tfvars    │                 │ tfvars    │
        └─────┬─────┘                 └─────┬─────┘
              │                             │
              └──────────────┬──────────────┘
                             │
              ┌──────────────┼──────────────┐
              │              │              │
         ┌────▼────┐    ┌────▼────┐   ┌────▼────┐
         │ EC2     │    │ S3      │   │ IAM     │
         │ Module  │    │ Module  │   │ Module  │
         └─────────┘    └─────────┘   └─────────┘
              │              │              │
              └──────────────┼──────────────┘
                             ▼
                    ┌──────────────────┐
                    │   AWS Account    │
                    │ (Remote S3 State │
                    │  + DynamoDB Lock)│
                    └──────────────────┘
```

---

## 📂 Repository Structure

```
terraform-aws-iac-platform/
├── modules/
│   ├── ec2/              # Reusable EC2 module (instance + SG + per-service IAM profile)
│   ├── s3/               # Reusable S3 module (encryption, versioning, public-access block)
│   └── iam/              # Least-privilege IAM roles & policies (no wildcards)
├── environments/
│   ├── dev/              # Dev environment composition + dev.tfvars
│   └── staging/          # Staging environment composition + staging.tfvars
├── .github/workflows/    # GitHub Actions: fmt, validate, tflint, tfsec, plan
├── docs/                 # Architecture docs and IAM policy notes
├── scripts/              # Helper scripts (init, plan, apply wrappers)
└── README.md
```

---

## 🚀 Quick Start

### Prerequisites
- Terraform `>= 1.6.0`
- AWS CLI configured (`aws configure`)
- An S3 bucket + DynamoDB table for remote state (see `docs/REMOTE_STATE.md`)

### Deploy Dev Environment
```bash
cd environments/dev
terraform init -backend-config=backend.hcl
terraform plan  -var-file=dev.tfvars
terraform apply -var-file=dev.tfvars
```

### Deploy Staging Environment
```bash
cd environments/staging
terraform init -backend-config=backend.hcl
terraform plan  -var-file=staging.tfvars
terraform apply -var-file=staging.tfvars
```

### Tear Down
```bash
terraform destroy -var-file=dev.tfvars
```

---

## 🔐 Security Principles

1. **Least Privilege IAM** — Every policy targets a specific resource ARN. No `*` actions, no `*` resources.
2. **Encryption at Rest** — All S3 buckets enforce SSE-S3 / SSE-KMS by default.
3. **No Public Buckets** — `BlockPublicAcls`, `IgnorePublicAcls`, `BlockPublicPolicy`, `RestrictPublicBuckets` all enabled.
4. **State Encryption** — Remote state stored encrypted in S3 with DynamoDB state-locking.
5. **Tag Compliance** — Every resource carries `Environment`, `Owner`, `ManagedBy=Terraform` tags.

See [`docs/IAM_POLICY.md`](docs/IAM_POLICY.md) for the full IAM design rationale.

---

## 🧪 CI/CD Pipeline

Every Pull Request automatically runs:

| Stage | Tool | Purpose |
|---|---|---|
| Format | `terraform fmt -check` | Style consistency |
| Validate | `terraform validate` | Syntax & schema correctness |
| Lint | `tflint` | Terraform best-practice rules |
| Security | `tfsec` | Static security analysis |
| Plan | `terraform plan` | Preview changes before merge |

See [`.github/workflows/terraform.yml`](.github/workflows/terraform.yml).

---

## 📊 Before vs After

| Dimension | Before (Click-Ops) | After (This Project) |
|---|---|---|
| Provisioning time | ~30 min/env | **~2 min/env** |
| Configuration drift | Frequent | **Zero** |
| Audit trail | None | **Full Git history** |
| Reproducibility | Manual snapshots | **Single command** |
| IAM permissions | Often `*:*` | **Resource-scoped** |
| Rollback | Manual & risky | **`terraform apply` previous commit** |

---

## 👤 Author

Built as a portfolio project demonstrating production-grade Terraform, AWS, and DevSecOps practices.

## 📜 License

MIT — see [LICENSE](LICENSE)
