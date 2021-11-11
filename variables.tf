variable "name" {
  description = "Name of Azure Databricks service."
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all resources"
  default     = true
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = "rg-demo-westeurope-01"
}

variable "location" {
  description = "The location/region to keep all your resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "westeurope"
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

variable "workspace_name" {
  type        = string
  description = "Name of Databricks workspace"
  default     = "dbw-workspace"
}

variable "sku_tier" {
  description = "The SKU that should be used for this Databricks Cluster. Possible values are standard and premium"
  type        = string
  default     = "standard"
}

variable "private_subnet_name" {
  type        = string
  description = "Name of the private subnet"
  default     = null
}

variable "vnet_id" {
  type        = string
  description = "ID of existing virtual network into which Databricks will be deployed"
  default     = null
}
