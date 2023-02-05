variable "name" {
  type        = string
  description = "Name of Databricks workspace"
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all resources"
  type        = bool
  default     = true
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
  default     = null
}

variable "managed_resource_group_name" {
  description = "The name of the resource group where Azure should place the managed Databricks resources. Changing this forces a new resource to be created."
  type        = string
}

variable "location" {
  description = "The location/region to keep all your resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "westeurope"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

variable "sku_tier" {
  description = "The SKU that should be used for this Databricks Cluster. Possible values are standard and premium"
  type        = string
  default     = "standard"
}

variable "vnet_id" {
  type        = string
  description = "ID of existing virtual network into which Databricks will be deployed"
  default     = null
}

variable "private_subnet_name" {
  type        = string
  description = "Name of the private subnet"
  default     = null
}

variable "public_network_access_enabled" {
  description = "(Optional) Allow public access for accessing workspace. Set value to false to access workspace only via private link endpoint. Possible values include true or false. Defaults to false."
  type        = bool
  default     = false
}

variable "network_security_group_rules_required" {
  description = "(Optional) Does the data plane (clusters) to control plane communication happen over private link endpoint only or publicly? Possible values AllRules, NoAzureDatabricksRules or NoAzureServiceRules. Required when public_network_access_enabled is set to false"
  type        = string
  default     = "AllRules"
}

variable "storage_account_name" {
  description = "(Optional) Default Databricks File Storage account name. Defaults to a randomized name(e.g. dbstoragel6mfeghoe5kxu). Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "storage_account_sku_name" {
  description = "(Optional) Storage account SKU name. Possible values include Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_GZRS, Standard_RAGZRS, Standard_ZRS, Premium_LRS or Premium_ZRS. Defaults to Standard_GRS. Changing this forces a new resource to be created."
  type        = string
  default     = "Standard_LRS"
}
