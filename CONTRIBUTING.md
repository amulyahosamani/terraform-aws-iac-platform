# Contributing

## Workflow
1. Create a feature branch: `git checkout -b feat/my-change`
2. Run locally before pushing:
   ```bash
   terraform fmt -recursive
   terraform validate          # in each environments/<env>
   tflint --recursive
   tfsec .
   ```
3. Open a Pull Request — CI runs the same checks across `dev` and `staging`.
4. Attach the `terraform plan` output to the PR description.
5. Merge requires: green CI + 1 reviewer + plan attached.

## Module Conventions
- Every module has `main.tf`, `variables.tf`, `outputs.tf`.
- Every variable has a `description` and (where useful) a `validation` block.
- No hardcoded values inside modules — everything via variables.
- No `*` in IAM actions or resources.
