# Permission set with policy options

This module creates an IAM Identity Center permission set, optionally attaches customer-managed policies, AWS-managed policies, and an inline policy, and assigns the permission set to a user or group in an AWS account. The root configuration also creates a customer-managed SSM policy and attaches it to `DeveloperAccess`.

## Example

```hcl
module "developer_access" {
  source = "./modules/permission-sets/permission-set-options-for-all-policies"

  permission_set_names          = "DeveloperAccess"
  customer_managed_policy_names = ["cloud-vm-access", "devops-readonly"]
  managed_policy_arns           = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  inline_policy_document        = data.aws_iam_policy_document.instance_inline_policy.json
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
| `customer_managed_policy_names` | `set(string)` | No | Optional names of existing customer-managed IAM policies to attach. Omit or set to `null` for no customer-managed attachments. The current resource configuration uses the root path (`/`). |
| `managed_policy_arns` | `set(string)` | No | Optional ARNs of AWS-managed IAM policies to attach. Omit or set to `null` for no AWS-managed attachments. |
| `inline_policy_document` | `string` | No | Optional JSON policy document to attach inline; defaults to `null` (no inline policy). |
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

The root configuration's `aws_iam_policy.ssm_remote_access` uses the `name_prefix` argument and the `aws_iam_policy_document.ssm_remote_access` data source. It grants `ssm:StartSession`, `ssm:SendCommand`, and `ssm:TerminateSession` on `*`; narrow the resources to the intended managed instances and SSM documents before production use. The generated customer-managed policy must exist in every AWS account where the permission set is provisioned. The root provider creates it only in the account selected by its credentials.
