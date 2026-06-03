# Resource Group

resource "azurerm_resource_group" "rg" {
  name     = "rg-vwan-aue"
  location = "Australia East"
}

# Virtual WAN

resource "azurerm_virtual_wan" "vwan" {
  name                = "vwan-aue"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  type = "Standard"
}

# Virtual Hub

resource "azurerm_virtual_hub" "hub" {
  name                = "hub-aue"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  virtual_wan_id = azurerm_virtual_wan.vwan.id
  address_prefix = "10.0.0.0/16"
}

####################################################
# PROD VNET
####################################################

resource "azurerm_virtual_network" "prod" {
  name                = "vnet-prod"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "prod_frontend" {
  name                 = "snet-frontend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.prod.name

  address_prefixes = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "prod_app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.prod.name

  address_prefixes = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "prod_db" {
  name                 = "snet-db"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.prod.name

  address_prefixes = ["10.1.3.0/24"]
}

####################################################
# DEV VNET
####################################################

resource "azurerm_virtual_network" "dev" {
  name                = "vnet-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "dev_frontend" {
  name                 = "snet-frontend"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.dev.name

  address_prefixes = ["10.2.1.0/24"]
}

resource "azurerm_subnet" "dev_app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.dev.name

  address_prefixes = ["10.2.2.0/24"]
}

resource "azurerm_subnet" "dev_db" {
  name                 = "snet-db"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.dev.name

  address_prefixes = ["10.2.3.0/24"]
}

####################################################
# VNET CONNECTIONS TO VWAN HUB
####################################################

resource "azurerm_virtual_hub_connection" "prod_connection" {
  name                      = "prod-vnet-connection"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.prod.id

  internet_security_enabled = false
}

resource "azurerm_virtual_hub_connection" "dev_connection" {
  name                      = "dev-vnet-connection"
  virtual_hub_id            = azurerm_virtual_hub.hub.id
  remote_virtual_network_id = azurerm_virtual_network.dev.id

  internet_security_enabled = false
}