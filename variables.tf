variable "resource_group_name" {
  default = "rg-smb-fileserver"
}

variable "location" {
  default = "South Central US"
}

variable "storage_account_name" {
  description = "Must be globally unique, lowercase, 3-24 chars"
  type        = string
}

variable "file_share_quota_gb" {
  default = 50
}