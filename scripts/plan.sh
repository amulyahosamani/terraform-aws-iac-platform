#!/usr/bin/env bash
###############################################################################
# Convenience wrapper: ./scripts/plan.sh <env>
# Example:             ./scripts/plan.sh dev
###############################################################################
set -euo pipefail

ENV="${1:?Usage: $0 <dev|staging>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="${ROOT}/environments/${ENV}"

if [[ ! -d "${DIR}" ]]; then
  echo "❌ Environment '${ENV}' not found in ${ROOT}/environments"
  exit 1
fi

cd "${DIR}"
echo "🔧 terraform init  (${ENV})"
terraform init -backend-config=backend.hcl -reconfigure

echo "📐 terraform fmt"
terraform fmt -recursive "${ROOT}"

echo "✅ terraform validate"
terraform validate

echo "📋 terraform plan  (${ENV})"
terraform plan -var-file="${ENV}.tfvars" -out="${ENV}.tfplan"

echo "✨ Plan saved to ${DIR}/${ENV}.tfplan"
