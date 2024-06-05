resource "random_password" "password" {
  length = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_postgresql_flexible_server" "aj-postgreSQL-flex-abc" {
  name                = "aj-postgre-flex-abc"
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
  location            = azurerm_resource_group.aj-rg-abc.location
  version             = "12" 
  storage_mb          = 32768 # 32GB
  administrator_login = "adminuser"
  administrator_password = random_password.password.result
  sku_name            = "GP_Standard_D4s_v3"

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.user-id.id]
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres_vnet_link
  ]
}

# Ensure Entra ID Authentication is enabled
resource "azurerm_postgresql_flexible_server_configuration" "EntraID_auth_only" {
  name                = "EntraID_auth_only"
  server_id         = azurerm_postgresql_flexible_server.aj-postgreSQL-flex-abc.id
  value               = "true"
}

# Assign your user account as admin
resource "azurerm_role_assignment" "RBAC" {
  scope                = azurerm_postgresql_flexible_server.aj-postgreSQL-flex-abc.id
  role_definition_name = "Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Create User Assigned Managed Identity for PostgreSQL
resource "azurerm_user_assigned_identity" "user-id" {
  name                = "user-id"
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
  location            = azurerm_resource_group.aj-rg-abc.location
}