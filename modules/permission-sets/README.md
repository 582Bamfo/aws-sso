# Permission-set modules

This directory contains focused modules that create one IAM Identity Center permission set, configure its policy, and assign it to a user or group in an AWS account.

## Subdirectories

- [permission-set-customer-managed/](permission-set-customer-managed/README.md) — attaches one or more existing customer-managed IAM policies by name and path, then creates an account assignment.
- [permission-set-inline/](permission-set-inline/README.md) — attaches an inline policy document, then creates an account assignment.

## Identity source prerequisite

These permission-set modules assume that users and groups are managed outside Terraform in Microsoft Entra ID and provisioned into AWS IAM Identity Center. Configure Entra ID as the external identity provider: use SAML for user sign-in/federation and SCIM for provisioning users and groups (including group membership) into Identity Center. Complete and test that integration before using these modules.

The modules do not create Entra ID users or groups. Supply the ID of the already-provisioned Identity Center user or group as `principal_id`, along with `USER` or `GROUP` as `principal_type`; do not supply a display name or Entra object ID unless it is also the corresponding Identity Center ID. Customer-managed IAM policies must exist in the target account with matching names and paths. Review the plan to verify the intended account and permissions before applying.
