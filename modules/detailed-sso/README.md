# Detailed IAM Identity Center examples

This directory groups Terraform configurations that separate permission-set management from account assignments.

## Subdirectories

- [permissions-set/](permissions-set/README.md) — creates permission sets and Identity Center users/groups, attaches AWS-managed or inline policies, and creates account assignments.
- [account-assignment/](account-assignment/README.md) — creates users/groups and account assignments from an `account_assignments` input list.

Both configurations currently create identities from the supplied names and contain implementation assumptions that should be reviewed before use. They are not drop-in replacements for a deployment that relies on an external identity provider. Run Terraform validation and carefully inspect a plan in a non-production environment first.
