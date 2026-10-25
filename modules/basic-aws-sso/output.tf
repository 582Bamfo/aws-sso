# Retrieve the Identity Store ID (needed for users & groups)
output "identity_store_id" {
  value = data.aws_ssoadmin_instances.sso.identity_store_ids[0]
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}