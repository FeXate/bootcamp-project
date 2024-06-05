# Key Vault DNS Zone
resource "azurerm_private_dns_zone" "keyvault_zone" {
  name = "keyvault.DNS.azure.com"
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
}

# PostgreSQL Flexible Server DNS Zone
resource "azurerm_private_dns_zone" "postgre_zone" {
  name = "SQL.postgres.database.azure.com"
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
}

# Link VNET to Key Vault DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "keyvault_vnet_link" {
  name                  = "keyvaultLink"
  resource_group_name   = azurerm_resource_group.aj-rg-abc.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault_zone.name
  virtual_network_id    = azurerm_virtual_network.aj-vnet1-abc.id
}

# Link VNET to PostgreSQL DNS Zone
resource "azurerm_private_dns_zone_virtual_network_link" "postgres_vnet_link" {
  name                  = "postgresLink"
  resource_group_name   = azurerm_resource_group.aj-rg-abc.name
  private_dns_zone_name = azurerm_private_dns_zone.postgre_zone.name
  virtual_network_id    = azurerm_virtual_network.aj-vnet1-abc.id
}