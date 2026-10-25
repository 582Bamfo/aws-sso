# Detailed permission-set example

This Terraform configuration creates one permission set per distinct `permission_set_name` supplied in the `account_assignments` list. It can attach AWS-managed policies and inline policies using maps keyed by permission-set name. It also contains resources to create Identity Center users/groups and account assignments.

## Inputs

The input variables are declared in `main.tf`:

| Name | Type | Required | Description |
|---|---|---:|---|
| `account_assignments` | `list(object)` | Yes | Records containing `account`, `permission_set_name`, `principal_name`, and `principal_type`. |
| `permission_set_policies` | `map(string)` | No | Map of permission-set names to AWS-managed policy ARNs; defaults to `{}`. |
| `permission_set_inline_policies` | `map(string)` | No | Map of permission-set names to inline policy JSON; defaults to `{}`. |
| `email_domain` | `string` | No | Email domain used when creating users; defaults to `example.com`. |

## Example

```hcl
account_assignments = [
  {
    account             = "123456789012"
    permission_set_name = "ReadOnlyAccess"
    principal_name      = "example-user"
    principal_type      = "USER"
  }
]

permission_set_policies = {
  ReadOnlyAccess = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

permission_set_inline_policies = {}
email_domain = "example.com"
```

## Important implementation notes

- For an Entra ID external identity-source setup, configure SAML for sign-in/federation and SCIM to provision users and groups into IAM Identity Center. Permission-set assignments should use the resulting Identity Center principal IDs; Entra user/group management and provisioning are prerequisites, not permission-set responsibilities.
- This configuration currently creates users and groups from assignment records, so it is not suitable as-is for identities managed in Entra ID and provisioned by SCIM. Refactor those identity-creation resources to look up existing Identity Center principals before using this module in that setup.
- Review `main.tf` before applying. The current membership resource derives group IDs using `permission_set_name`; verify and correct this association logic for your intended user/group model.
- The managed-policy and inline-policy maps are indexed by permission-set name, so each key must correspond to a permission set created by `account_assignments`.
- Test in a non-production environment and inspect the Terraform plan before granting access.
