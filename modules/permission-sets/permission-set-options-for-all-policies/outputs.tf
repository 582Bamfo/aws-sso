output "permission_set_arn" {
  description = "ARN of the created IAM Identity Center permission set."
  value       = aws_ssoadmin_permission_set.developer_access.arn
}

output "permission_set_name" {
  description = "Name of the created IAM Identity Center permission set."
  value       = aws_ssoadmin_permission_set.developer_access.name
}

output "instance_arn" {
  description = "ARN of the IAM Identity Center instance containing the permission set."
  value       = aws_ssoadmin_permission_set.developer_access.instance_arn
}

output "account_assignment_id" {
  description = "ID of the account assignment created for the configured principal and account."
  value       = aws_ssoadmin_account_assignment.example.id
}

output "customer_managed_policy_names" {
  description = "Customer-managed policy names attached to the permission set."
  value       = keys(aws_ssoadmin_customer_managed_policy_attachment.developer_access)
}

output "managed_policy_arns" {
  description = "AWS-managed policy ARNs attached to the permission set."
  value       = keys(aws_ssoadmin_managed_policy_attachment.developer_access)
}

output "inline_policy_attached" {
  description = "Whether the optional inline policy is attached to the permission set."
  value       = length(aws_ssoadmin_permission_set_inline_policy.developer_access) > 0
}
