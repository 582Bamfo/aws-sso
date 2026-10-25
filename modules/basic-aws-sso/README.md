# Basic AWS IAM Identity Center example

This folder contains a standalone example that looks up the first IAM Identity Center instance in the configured region, creates a user and a group, adds the user to the group, creates an administrator permission set, attaches the AWS-managed `AdministratorAccess` policy, and assigns that permission set to the group in the current AWS account.

## Requirements

- AWS provider credentials with permission to manage IAM Identity Center, Identity Store, and account assignments.
- IAM Identity Center enabled in the configured AWS region.
- Terraform initialized in this folder.

## Important security notes

- This is a demonstration, not a least-privilege production configuration. It grants full administrator access to the group.
- The user details, group name, permission-set name, region, and policy are hard-coded in the Terraform files. Review and replace them before planning or applying.
- The example creates Identity Center identities. If your organization synchronizes users and groups from an external identity provider, use the provisioned identities instead of creating duplicates.
- Confirm the target account and inspect the Terraform plan before applying.

## Outputs

- `identity_store_id` — Identity Store ID for the discovered Identity Center instance.
- `aws_account_id` — AWS account ID resolved from the active credentials.
