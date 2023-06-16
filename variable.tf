variable "resource_group_location" {
  type        = string
  default     = "switzerlandnorth"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  description = "Name the resource group."
}

variable "prefix" {
  description = "Enter the prefix for the resource names"
  type        = string
}