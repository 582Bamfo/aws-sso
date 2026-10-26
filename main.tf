provider "aws" {
  region = "eu-west-2"
}

module "permission_sets" {
  source                        = "./modules/permission-sets/permission-set-customer-managed"
  permission_set_names          = "DeveloperAccess"
  customer_managed_policy_names = ["cloud-vm-access", "cyber-sec-role-policy", "devops-readonly"]
  managed_policy_arns           = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  inline_policy_document        = data.aws_iam_policy_document.instance_inline_policy.json
  session_duration              = "PT2H" # 2-hour session
  principal_id                  = "a6c2c244-2021-7057-cddb-3ae50d1a9605"
  principal_type                = "USER"
  target_id                     = "449325664824"
  target_type                   = "AWS_ACCOUNT"
  tags = {
    owner        = "SimplyDanTech"
    managed_by   = "Terraform"
    service      = "AWS SSO"
    organization = "SimplyDanTech"
  }
}


module "qa_permission_sets" {
  source                        = "./modules/permission-sets/permission-set-customer-managed"
  permission_set_names          = "QAAccess"
  customer_managed_policy_names = ["dev-rds-policy-qa", "free-cloud-course-iam-perm"]
  session_duration              = "PT1H" # 1-hour session
  principal_type                = "USER"
  target_id                     = "449325664824"
  target_type                   = "AWS_ACCOUNT"
  principal_id                  = "a6c2c244-2021-7057-cddb-3ae50d1a9605" # Replace with the actual group ID
  tags = {
    owner        = "SimplyDanTech"
    managed_by   = "Terraform"
    service      = "AWS SSO"
    organization = "SimplyDanTech"
  }
}


module "inline-permission-set" {
  source                 = "./modules/permission-sets/permission-set-inline"
  permission_set_names   = "InlinePolicyAccess"
  inline-policy-document = data.aws_iam_policy_document.in-line_policy.json
  session_duration       = "PT1H" # 1-hour session
  principal_type         = "USER"
  target_id              = "449325664824"
  target_type            = "AWS_ACCOUNT"
  principal_id           = "a6c2c244-2021-7057-cddb-3ae50d1a9605" # Replace with the actual group ID
  tags = {
    owner        = "SimplyDanTech"
    managed_by   = "Terraform"
    service      = "AWS SSO"
    organization = "SimplyDanTech"
  }
}

output "developer_access_permission_set_arn" {
  description = "ARN of the DeveloperAccess permission set."
  value       = module.permission_sets.permission_set_arn
}

output "developer_access_account_assignment_id" {
  description = "ID of the DeveloperAccess account assignment."
  value       = module.permission_sets.account_assignment_id
}
