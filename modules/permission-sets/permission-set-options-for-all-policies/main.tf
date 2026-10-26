data "aws_ssoadmin_instances" "simplydantech" {}

# Create a permission set for the specified SSO instance
resource "aws_ssoadmin_permission_set" "developer_access" {
  name             = var.permission_set_names
  description      = "Permission set for ${var.permission_set_names}"
  session_duration = var.session_duration
  instance_arn     = tolist(data.aws_ssoadmin_instances.simplydantech.arns)[0]
  tags             = var.tags

}

# Attach customer-managed IAM policies to the permission set
resource "aws_ssoadmin_customer_managed_policy_attachment" "developer_access" {
  for_each = var.customer_managed_policy_names == null ? toset([]) : var.customer_managed_policy_names

  instance_arn       = aws_ssoadmin_permission_set.developer_access.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer_access.arn
  customer_managed_policy_reference {
    name = each.value
    path = "/"
  }
}
#attach AWS-managed IAM policies to the permission set
resource "aws_ssoadmin_managed_policy_attachment" "developer_access" {
  for_each = var.managed_policy_arns == null ? toset([]) : var.managed_policy_arns

  instance_arn       = aws_ssoadmin_permission_set.developer_access.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer_access.arn
  managed_policy_arn = each.value
}

# Attach an inline IAM policy to the permission set
resource "aws_ssoadmin_permission_set_inline_policy" "developer_access" {
  count = var.inline_policy_document == null ? 0 : 1

  instance_arn       = aws_ssoadmin_permission_set.developer_access.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer_access.arn
  inline_policy      = var.inline_policy_document
}

#assign the permission set to a user or group in the specified AWS account

resource "aws_ssoadmin_account_assignment" "account_assignment" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.simplydantech.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.developer_access.arn

  principal_id   = var.principal_id
  principal_type = var.principal_type

  target_id   = var.target_id
  target_type = var.target_type

}
