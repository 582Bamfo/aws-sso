
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

  # You'll need to provide these required fields
  display_name = each.key
  name {
    given_name  = each.key # You might want to split the username or use a different value
    family_name = "User"   # You might want to provide this as a variable
  }
  emails {
    value   = "${each.key}@yourdomain.com" # You might want to provide domain as a variable
    primary = true
  }
}

# Create group memberships
resource "aws_identitystore_group_membership" "this" {
  for_each = {
    for a in var.account_assignments :
    format("%v-%v", a.principal_name, a.principal_type) => a
    if a.principal_type == "USER" # Only create memberships for users
  }

  identity_store_id = local.identity_store_id
  group_id         = aws_identitystore_group.this[each.value.permission_set_name].group_id
  member_id        = aws_identitystore_user.this[each.value.principal_name].user_id
}

# Create the account assignments
resource "aws_ssoadmin_account_assignment" "this" {
  for_each = local.assignment_map

  instance_arn      = local.sso_instance_arn
  permission_set_arn = each.value.permission_set_arn
  principal_id      = each.value.principal_type == "GROUP" ? 
    aws_identitystore_group.this[each.value.principal_name].group_id : 
    aws_identitystore_user.this[each.value.principal_name].user_id
  principal_type    = each.value.principal_type
  target_id        = each.value.account
  target_type      = "AWS_ACCOUNT"
}

