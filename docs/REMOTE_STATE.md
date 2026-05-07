# Remote State Bootstrap

This project uses **S3 + DynamoDB** for remote state storage and locking.
Bootstrap once per AWS account before running any environment.

## 1. Create the state bucket
```bash
aws s3api create-bucket \
  --bucket my-org-terraform-state \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket my-org-terraform-state \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket my-org-terraform-state \
  --server-side-encryption-configuration '{
    "Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]
  }'

aws s3api put-public-access-block \
  --bucket my-org-terraform-state \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
```

## 2. Create the lock table
```bash
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1
```

## 3. Update `backend.hcl` in each environment
Replace `REPLACE-WITH-YOUR-TFSTATE-BUCKET` with `my-org-terraform-state`.

## 4. Init
```bash
cd environments/dev
terraform init -backend-config=backend.hcl
```
