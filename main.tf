#-------------------------------
# Local Declarations
#-------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp[*].name, azurerm_resource_group.rg[*].name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp[*].location, azurerm_resource_group.rg[*].location, [""]), 0)
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#---------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  #ts:skip=AC_AZURE_0389 RSG lock should be skipped for now.
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags, )
}

#---------------------------------------------------------
# Databricks Creation or selection
#---------------------------------------------------------

resource "azurerm_databricks_workspace" "main" {
  name                                  = var.name
  resource_group_name                   = local.resource_group_name
  managed_resource_group_name           = var.managed_resource_group_name
  public_network_access_enabled         = var.public_network_access_enabled
  network_security_group_rules_required = var.public_network_access_enabled == false ? "NoAzureDatabricksRules" : var.network_security_group_rules_required
  location                              = local.location
  sku                                   = var.sku_tier
  tags                                  = var.tags
  custom_parameters {
    no_public_ip             = true
    private_subnet_name      = var.private_subnet_name
    virtual_network_id       = var.vnet_id
    storage_account_name     = var.storage_account_name
    storage_account_sku_name = var.storage_account_sku_name
  }
}
