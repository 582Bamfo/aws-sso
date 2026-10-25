# Permission Set with Inline Policy and Account Assignment

This module creates an AWS IAM Identity Center permission set, attaches an inline IAM policy to it, and assigns the permission set to an existing Identity Center user or group in an AWS account.

The permission set's inline policy defines the permissions granted when the principal assumes the permission set in the target account. The account assignment links the permission set to a principal; it does not create the Identity Center user or group.

## Prerequisites

- AWS provider credentials with permission to manage IAM Identity Center permission sets and account assignments.
- IAM Identity Center enabled, with an instance available in the configured AWS region.
- Microsoft Entra ID configured as IAM Identity Center's external identity provider: SAML provides sign-in/federation, while SCIM provisions users and groups (and group membership) into the Identity Center identity store.
- The user or group already provisioned in the Identity Center identity store by SCIM. Use its Identity Center ID as `principal_id`, not its display name or Entra object ID.
- The target AWS account included in the Identity Center organization/instance.
- The inline policy supplied as a valid JSON policy document string.

This module manages the permission set and its account assignment only. It does not create or manage Entra ID users/groups, configure SAML or SCIM, or create Identity Center identities. Maintain those identities and group memberships in Entra ID and keep the SCIM provisioning integration healthy.

## Usage

```hcl
module "developer_access" {
  source = "./modules/permission-sets/permission-set-inline"

  permission_set_names  = "DeveloperAccess"
  inline-policy-document = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:ListAllMyBuckets"]
      Resource = "*"
    }]
  })

  target_id     = "123456789012"
  target_type   = "AWS_ACCOUNT"
  principal_id  = "d-1234567890"
  principal_type = "GROUP" # or "USER"

  # Required by the module's input declaration; currently not applied to the permission set.
  session_duration = "PT1H"
}
```

The assignment depends on the inline-policy resource, so Terraform applies the policy before creating the account assignment.

## Inputs

| Name | Type | Required | Description |
|---|---|---:|---|
| `permission_set_names` | `string` | Yes | Name of the permission set to create. |
| `inline-policy-document` | `string` | Yes | JSON policy document attached as the permission set's inline policy. |
| `target_id` | `string` | Yes | 12-digit AWS account ID to receive the assignment. |
| `target_type` | `string` | Yes | Must be `AWS_ACCOUNT`. |
| `principal_id` | `string` | Yes | Identity Center ID of the user or group. |
| `principal_type` | `string` | Yes | `USER` or `GROUP`. |
| `session_duration` | `string` | Yes | Declared input; currently not applied to the permission set. |
| `tags` | `map(string)` | No | Has module defaults; currently not applied to the permission set. |

## Notes

- The module looks up the first IAM Identity Center instance returned in the configured region.
- The account assignment resource currently uses `AWS_ACCOUNT` as its target type. `target_type` is validated as `AWS_ACCOUNT`, but the resource is hard-coded to that value.
- Changes to the inline policy or assignments can take a short time to propagate through IAM Identity Center.
