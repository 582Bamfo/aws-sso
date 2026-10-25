

variable "inline-policy-document" {
  type = string
}

variable "session_duration" {
  description = "The session duration for the permission set."
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

variable "permission_set_names" {
  description = "Names of permission sets to create."
  type        = string
}


variable "target_id" {
  type        = string
  description = "12-digit AWS account ID to assign the permission set to."
}

variable "principal_id" {
  type        = string
  description = "AWS Identity Center user or group ID."
}

variable "principal_type" {
  type        = string
  description = "Principal type: USER or GROUP."

  validation {
    condition     = contains(["USER", "GROUP"], var.principal_type)
    error_message = "principal_type must be USER or GROUP."
  }
}

variable "target_type" {
  type        = string
  description = "Target type: AWS_ACCOUNT."

  validation {
    condition     = var.target_type == "AWS_ACCOUNT"
    error_message = "target_type must be AWS_ACCOUNT."
  }
}