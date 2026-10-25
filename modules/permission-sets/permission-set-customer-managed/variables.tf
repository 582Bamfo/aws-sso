variable "permission_set_names" {
  description = "Names of permission sets to create."
  type        = string

}

variable "customer_managed_policy_names" {
  description = "Names of existing customer-managed IAM policies to attach to the permission set."
  type        = set(string)
}

variable "session_duration" {
  description = "The duration of the SSO session for the permission set."
  type        = string
  default     = "PT1H"  # Default to 1 hour
}

variable "principal_type" {
  description = "The type of principal (USER or GROUP) for the account assignment."
  type        = string
  
}

variable "target_id" {
  description = "The AWS account ID where the permission set will be assigned."
  type        = string
}

variable "target_type" {
  description = "The type of target (AWS_ACCOUNT) for the account assignment."
  type        = string
  default     = "AWS_ACCOUNT"
}

variable "principal_id" {
  description = "The ID of the principal (user or group) to which the permission set will be assigned."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the permission set."
  type        = map(string)
  default     = {
    owner       = "SimplyDanTech"
    managed_by = "Terraform"
    service    = "AWS SSO"
    organization = "SimplyDanTech"
  }
}