# Fetch AWS IAM Identity Center (SSO) Instance Details
data "aws_ssoadmin_instances" "sso" {}

data "aws_caller_identity" "current" {}


