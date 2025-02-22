
# Create a User (Dan)
resource "aws_identitystore_user" "dan" {
  identity_store_id = data.aws_ssoadmin_instances.sso.identity_store_ids[0]
  user_name        = "dan@gmail.com"
  display_name     = "Dan"

  emails {
    value   = "dan@gmail.com"
    primary = true
  }

  name {
    given_name  = "Dan"
    family_name = "Bamfo"
  }
}

# Create a Group (DevOps)
resource "aws_identitystore_group" "devops" {
  identity_store_id = data.aws_ssoadmin_instances.sso.identity_store_ids[0]
  display_name      = "DevOps"
  description       = "DevOps Team"
}

# Add Dan to the DevOps Group
resource "aws_identitystore_group_membership" "dan_devops" {
  identity_store_id = data.aws_ssoadmin_instances.sso.identity_store_ids[0]
  group_id          = aws_identitystore_group.devops.group_id
  member_id         = aws_identitystore_user.dan.user_id
}

# Create an Administrator Access Permission Set
resource "aws_ssoadmin_permission_set" "admin_access" {
  instance_arn    = data.aws_ssoadmin_instances.sso.arns[0]
  name            = "AdministratorAccess-dev"
  description     = "Provides full administrative access"
  session_duration = "PT8H"  # 8-hour session

}

resource "aws_ssoadmin_managed_policy_attachment" "example" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.sso.arns)[0]
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn
}
# Assign DevOps Group to an AWS Account with Admin Access
resource "aws_ssoadmin_account_assignment" "devops_admin" {
  instance_arn       = data.aws_ssoadmin_instances.sso.arns[0]
  permission_set_arn = aws_ssoadmin_permission_set.admin_access.arn
  principal_id       = aws_identitystore_group.devops.group_id
  principal_type     = "GROUP"
  target_id          = data.aws_caller_identity.current.account_id  # Replace with your AWS Account ID
  target_type        = "AWS_ACCOUNT"
}
