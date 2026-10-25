# AWS IAM Identity Center Terraform workspace

This repository contains Terraform examples/modules for managing AWS IAM Identity Center (formerly AWS SSO): permission sets, policy attachments, users and groups, and account assignments.

## Repository layout

- [modules/README.md](modules/README.md) — module index.
- [modules/basic-aws-sso/README.md](modules/basic-aws-sso/README.md) — hard-coded end-to-end example.
- [modules/detailed-sso/README.md](modules/detailed-sso/README.md) — detailed module index.
- [modules/permission-sets/README.md](modules/permission-sets/README.md) — focused permission-set modules.

The root Terraform configuration in `main.tf` demonstrates calling the customer-managed and inline-policy permission-set modules. Review it and replace account IDs, principal IDs, region, policy names, and access grants with values appropriate to your environment before applying.

## Requirements and safety

- Terraform and the AWS provider, configured with credentials that can manage IAM Identity Center and IAM resources.
- IAM Identity Center enabled in the AWS account/organization and configured in the provider's region.
- Before applying, inspect the plan carefully. These configurations can create or change identity resources and grant access to AWS accounts. The basic example grants the AWS-managed `AdministratorAccess` policy.
- Keep Terraform state secure. State files may contain sensitive infrastructure details; do not commit state files or credentials.

## Typical workflow

From the repository root, initialize Terraform, review a plan, and apply only after verifying the proposed changes. Use the same backend and workspace consistently so state remains aligned with the resources managed by Terraform.

The examples are educational and may require adjustment for your identity source, account topology, and organization's security requirements.
