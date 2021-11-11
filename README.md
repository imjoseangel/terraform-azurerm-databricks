# terraform-azurerm-databricks

[![Terraform](https://github.com/imjoseangel/terraform-azurerm-databricks/actions/workflows/terraform.yml/badge.svg)](https://github.com/imjoseangel/terraform-azurerm-databricks/actions/workflows/terraform.yml)

## Deploys a databricks cluster on dbw with application gateway support. Monitoring support can be added through Azure Log Analytics

This Terraform module deploys a databricks cluster on Azure using dbw (Azure databricks Service)

### NOTES

* A SystemAssigned identity will be created by default.
* databricks Version is set to Current.
* Role Based Access Control is always enabled.

## Usage in Terraform 1.0

```terraform
data "azurerm_resource_group" "dbwvnetrsg" {
  name = "vnetrsg-dbw"
}

data "azurerm_virtual_network" "dbwvnet" {
  name                = "vnet-dbw"
  resource_group_name = data.azurerm_resource_group.dbwvnetrsg.name
}

resource "azurerm_subnet" "dbwsubnet" {
  name                 = "subnet-dbwnodes"
  resource_group_name  = data.azurerm_resource_group.dbwvnetrsg.name
  virtual_network_name = data.azurerm_virtual_network.dbwvnet.name
  address_prefixes     = ["10.100.10.0/24"]
}

module "dbw" {
  source                    = "github.com/imjoseangel/terraform-azurerm-databricks"
  name                      = "dbwname"
  resource_group_name       = "rsg-dbw"
  location                  = "westeurope"
  prefix                    = "dbwdns"
  sku_tier                  = "Free"
  create_resource_group     = true
  oms_agent_enabled         = false
  agents_availability_zones = ["1", "2"]
  private_cluster_enabled   = false # default value
  vnet_subnet_id            = azurerm_subnet.dbwsubnet.id
  create_ingress            = true # defaults to false
  gateway_id                = azurerm_application_gateway.appgateway.id # id of the application gw for ingress
  enable_auto_scaling       = true
  max_default_node_count    = 3
  min_default_node_count    = 1
}

resource "azurerm_role_assignment" "dbw_resource_group" {
  scope                = data.azurerm_resource_group.dbwvnetrsg.id
  role_definition_name = "Network Contributor"
  principal_id         = module.dbw.system_assigned_identity[0].principal_id
}
```

The module supports some outputs that may be used to configure a databricks
provider after deploying an dbw cluster.

```terraform
provider "databricks" {
  host                   = module.dbw.host
  client_certificate     = base64decode(module.dbw.client_certificate)
  client_key             = base64decode(module.dbw.client_key)
  cluster_ca_certificate = base64decode(module.dbw.cluster_ca_certificate)
}
```

## Authors

Originally created by [imjoseangel](http://github.com/imjoseangel)

## License

[MIT](LICENSE)
