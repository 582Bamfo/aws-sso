locals {
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
  sso_instance_arn  = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  
  # Create lists of users and groups from the assignments
  group_list = toset([for mapping in var.account_assignments : mapping.principal_name if mapping.principal_type == "GROUP"])
  user_list  = toset([for mapping in var.account_assignments : mapping.principal_name if mapping.principal_type == "USER"])
  
  # Create assignment map
  assignment_map = {
    for a in var.account_assignments :
    format("%v-%v-%v-%v", a.account, substr(a.principal_type, 0, 1), a.principal_name, a.permission_set_name) => a
  }
}
