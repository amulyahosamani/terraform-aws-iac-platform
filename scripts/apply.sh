#!/usr/bin/env bash
###############################################################################
# Convenience wrapper: ./scripts/apply.sh <env>
###############################################################################
set -euo pipefail

ENV="${1:?Usage: $0 <dev|staging>}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
DIR="${ROOT}/environments/${ENV}"

cd "${DIR}"

if [[ ! -f "${ENV}.tfplan" ]]; then
  echo "❌ No plan file found. Run ./scripts/plan.sh ${ENV} first."
  exit 1
fi

echo "🚀 terraform apply  (${ENV})"
terraform apply "${ENV}.tfplan"
