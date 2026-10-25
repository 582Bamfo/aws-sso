data "aws_ssoadmin_instances" "simplydantech" {}

resource "aws_ssoadmin_permission_set" "developer_access" {
  name         = var.permission_set_names
  description  = "Permission set for ${var.permission_set_names}"
  session_duration = var.session_duration
  instance_arn = tolist(data.aws_ssoadmin_instances.simplydantech.arns)[0]
  tags        = var.tags

}


resource "aws_ssoadmin_customer_managed_policy_attachment" "developer_access" {
  for_each = var.customer_managed_policy_names

  instance_arn       = aws_ssoadmin_permission_set.developer_access.instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.developer_access.arn
  customer_managed_policy_reference {
    name = each.value
    path = "/"
  }
}


resource "aws_ssoadmin_account_assignment" "example" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.simplydantech.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.developer_access.arn

  principal_id   = var.principal_id
  principal_type = var.principal_type

  target_id   = var.target_id
  target_type = var.target_type

}