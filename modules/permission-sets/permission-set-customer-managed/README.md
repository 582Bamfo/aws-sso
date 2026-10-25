# Customer-managed policy permission set

This module creates a single IAM Identity Center permission set, attaches each named customer-managed IAM policy, and assigns the permission set to a user or group in an AWS account.

## Example

```hcl
module "developer_access" {
  source = "./modules/permission-sets/permission-set-customer-managed"

  permission_set_names          = "DeveloperAccess"
  customer_managed_policy_names = ["cloud-vm-access", "devops-readonly"]
  session_duration              = "PT2H"

  principal_id   = "identity-center-principal-id"
  principal_type = "USER" # or "GROUP"
  target_id      = "123456789012"
  target_type    = "AWS_ACCOUNT"

  tags = {
    owner      = "ExampleTeam"
    managed_by = "Terraform"
  }
}
```

## Inputs

| Name | Type | Required | Description |
|---|---|---:|---|
| `permission_set_names` | `string` | Yes | Permission-set name. |
| `customer_managed_policy_names` | `set(string)` | Yes | Names of existing customer-managed IAM policies to attach. The current resource configuration uses the root path (`/`). |
| `principal_id` | `string` | Yes | IAM Identity Center ID of the user or group, not its display name. |
| `principal_type` | `string` | Yes | Principal type, normally `USER` or `GROUP`. |
| `target_id` | `string` | Yes | 12-digit AWS account ID. |
| `target_type` | `string` | No | Assignment target type; defaults to `AWS_ACCOUNT`. |
| `session_duration` | `string` | No | Permission-set session duration; defaults to `PT1H`. |
| `tags` | `map(string)` | No | Permission-set tags; has module defaults. |

## Prerequisites and notes

- IAM Identity Center must be enabled and configured to use Microsoft Entra ID as its external identity provider. SAML is used for sign-in/federation; SCIM provisions Entra ID users and groups, including group membership, into the Identity Center identity store.
- The referenced user or group must already have been provisioned into Identity Center by SCIM. Pass its Identity Center ID, not its display name or Entra object ID. This module does not create or manage Entra ID/Identity Center identities or configure SAML/SCIM.
- Each policy must exist in the AWS account with the supplied name and root path. Customer-managed policy references must also be available in the accounts where the permission set is provisioned.
- The module selects the first Identity Center instance returned in the configured region.
- Review the Terraform plan to ensure that the permission set and assignment grant only the intended access.
