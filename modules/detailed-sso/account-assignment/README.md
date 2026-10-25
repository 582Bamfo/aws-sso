# Detailed account-assignment example

This Terraform module is intended to create IAM Identity Center users and groups from the supplied assignment records, then assign existing permission sets to those principals in AWS accounts. It discovers the first IAM Identity Center instance in the configured region.

## Input

The module declares one input, `account_assignments`, a list of objects with these attributes:

| Attribute | Type | Description |
|---|---|---|
| `account` | `string` | 12-digit AWS account ID to assign. |
| `permission_set_name` | `string` | Name used to identify the permission set in this configuration. |
| `permission_set_arn` | `string` | Existing permission-set ARN used by the account-assignment resource. |
| `principal_name` | `string` | Name used to create/identify the user or group. |
| `principal_type` | `string` | `USER` or `GROUP`. |

## Example input

```hcl
account_assignments = [
  {
    account             = "123456789012"
    permission_set_name = "ReadOnlyAccess"
    permission_set_arn  = "arn:aws:sso:::permissionSet/instance-id/permission-set-id"
    principal_name      = "example-user"
    principal_type      = "USER"
  }
]
```

## Important implementation notes

- This module creates Identity Center users and groups; it does not simply look up existing identities. Do not use it as-is when an external identity provider provisions those identities.
- The permission set must already exist and the supplied ARN must match the intended permission set.
- Review `main.tf` and test in a non-production environment before use. In particular, verify group-membership behavior and all principal-to-permission-set associations against your desired configuration.
- This README documents the code in this repository and is not documentation for an upstream Terraform module.
