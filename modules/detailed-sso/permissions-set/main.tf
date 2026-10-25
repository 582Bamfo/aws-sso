# Get the SSO instance
data "aws_ssoadmin_instances" "this" {}

locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  sso_instance_arn  = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  
  # Create lists of users and groups from the assignments
  group_list = toset([for mapping in var.account_assignments : mapping.principal_name if mapping.principal_type == "GROUP"])
  user_list  = toset([for mapping in var.account_assignments : mapping.principal_name if mapping.principal_type == "USER"])
  
  # Create map of unique permission sets
  permission_sets = toset([for mapping in var.account_assignments : mapping.permission_set_name])
  
  # Create assignment map
  assignment_map = {
    for a in var.account_assignments :
    format("%v-%v-%v-%v", a.account, substr(a.principal_type, 0, 1), a.principal_name, a.permission_set_name) => a
  }
}

# Create the permission sets
resource "aws_ssoadmin_permission_set" "this" {
  for_each         = local.permission_sets
  instance_arn     = local.sso_instance_arn
  name             = each.value
  description      = "Permission set for ${each.value}"
  session_duration = "PT8H"  # 8 hours - can be customized
}

# Attach managed policies to permission sets
resource "aws_ssoadmin_managed_policy_attachment" "this" {
  for_each           = var.permission_set_policies
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
  managed_policy_arn = each.value
}

# Attach inline policies to permission sets (if needed)
resource "aws_ssoadmin_permission_set_inline_policy" "this" {
  for_each           = var.permission_set_inline_policies
  instance_arn       = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.key].arn
  inline_policy      = each.value
}

# Create the groups
resource "aws_identitystore_group" "this" {
  for_each          = local.group_list
  identity_store_id = local.identity_store_id
  
  display_name = each.key
  description  = "Group for ${each.key}"
}

# Create the users
resource "aws_identitystore_user" "this" {
  for_each          = local.user_list
  identity_store_id = local.identity_store_id

  user_name = each.key
  display_name = each.key
  name {
    given_name  = each.key
    family_name = "User"
  }
  emails {
    value   = "${each.key}@${var.email_domain}"
    primary = true
  }
}

# Create group memberships
resource "aws_identitystore_group_membership" "this" {
  for_each = {
    for a in var.account_assignments :
    format("%v-%v", a.principal_name, a.principal_type) => a
    if a.principal_type == "USER"
  }

  identity_store_id = local.identity_store_id
  group_id         = aws_identitystore_group.this[each.value.permission_set_name].group_id
  member_id        = aws_identitystore_user.this[each.value.principal_name].user_id
}

# Create the account assignments
resource "aws_ssoadmin_account_assignment" "this" {
  for_each = local.assignment_map

  instance_arn      = local.sso_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.this[each.value.permission_set_name].arn
  principal_id      = each.value.principal_type == "GROUP" ? 
    aws_identitystore_group.this[each.value.principal_name].group_id : 
    aws_identitystore_user.this[each.value.principal_name].user_id
  principal_type    = each.value.principal_type
  target_id        = each.value.account
  target_type      = "AWS_ACCOUNT"
}

# Variables needed
variable "account_assignments" {
  type = list(object({
    account = string
    permission_set_name = string
    principal_name = string
    principal_type = string
  }))
  description = "List of account assignments"
}

variable "permission_set_policies" {
  type        = map(string)
  description = "Map of permission set names to AWS managed policy ARNs"
  default     = {}
}

variable "permission_set_inline_policies" {
  type        = map(string)
  description = "Map of permission set names to inline policy JSON"
  default     = {}
}

variable "email_domain" {
  type        = string
  description = "Domain for user email addresses"
  default     = "example.com"
}

# Example usage in terraform.tfvars:
/*
account_assignments = [
  {
    account = "123456789012"
    permission_set_name = "AdminAccess"
    principal_name = "john.doe"
    principal_type = "USER"
  }
]

permission_set_policies = {
  "AdminAccess" = "arn:aws:iam::aws:policy/AdministratorAccess"
  "ReadOnlyAccess" = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

permission_set_inline_policies = {
  "CustomAccess" = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:ListBucket"]
        Resource = ["*"]
      }
    ]
  })
}

email_domain = "company.com"
*/
