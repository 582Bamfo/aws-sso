# Terraform modules

This directory contains the IAM Identity Center examples and modules in this repository.

## Directories

| Directory | Purpose |
|---|---|
| [basic-aws-sso/](basic-aws-sso/README.md) | Single, hard-coded example that creates a user and group, defines an administrator permission set, and assigns the group to an account. |
| [detailed-sso/](detailed-sso/README.md) | More granular examples for permission sets and account assignments. |
| [permission-sets/](permission-sets/README.md) | Focused permission-set modules for customer-managed or inline policies, including an account assignment. |

Review each module's inputs and side effects before using it. In particular, the examples may create Identity Center identities rather than referencing identities already managed by an external identity source.
