provider "azurerm" {
  features {}
}

variable "prefix" {
  description = "Enter the prefix for the resource names"
  type        = string
  default     = "FFN-Workshop"
}

variable "resource_group_name" {
  description = "Enter the name for the resource group"
  type        = string
}

module "fortinet_integration" {
  source            = "./fortinet_integration"
  prefix            = var.prefix
  resource_group    = var.resource_group_name
}

output "vm_password" {
  value = module.fortinet_integration.vm_password
}
