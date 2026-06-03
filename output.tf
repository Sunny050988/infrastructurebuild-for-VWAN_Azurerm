output "virtual_wan_id" {
  value = azurerm_virtual_wan.vwan.id
}

output "virtual_hub_id" {
  value = azurerm_virtual_hub.hub.id
}

output "prod_vnet_id" {
  value = azurerm_virtual_network.prod.id
}

output "dev_vnet_id" {
  value = azurerm_virtual_network.dev.id
}