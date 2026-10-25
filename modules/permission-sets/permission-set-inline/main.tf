data "aws_ssoadmin_instances" "simplydantech" {}

resource "aws_ssoadmin_permission_set" "simplydantech" {
  name         = var.permission_set_names
  description  = "Permission set for ${var.permission_set_names}"
  instance_arn = tolist(data.aws_ssoadmin_instances.simplydantech.arns)[0]
}



resource "aws_ssoadmin_permission_set_inline_policy" "simplydantech" {
  inline_policy      = var.inline-policy-document
  instance_arn       = tolist(data.aws_ssoadmin_instances.simplydantech.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.simplydantech.arn
  
}


resource "aws_ssoadmin_account_assignment" "this" {
  instance_arn       = tolist(data.aws_ssoadmin_instances.simplydantech.arns)[0]
  permission_set_arn = aws_ssoadmin_permission_set.simplydantech.arn

  # Supply the Identity Center user or group ID—not its name.
  principal_id   = var.principal_id
  principal_type = var.principal_type # "USER" or "GROUP"

  target_id   = var.target_id # 12-digit AWS account ID
  target_type = "AWS_ACCOUNT"

  # Ensure the inline policy is in place before granting the assignment.
  depends_on = [
    aws_ssoadmin_permission_set_inline_policy.simplydantech
  ]
}