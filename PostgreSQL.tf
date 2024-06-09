data "azuread_service_principal" "principal" {
  display_name = "EDU Terraform Automation"
}

resource "random_password" "password" {
  length = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_postgresql_flexible_server" "aj-postgreSQL-flex-abc" {
  name                = "aj-postgre-flex-abc"
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
  location            = azurerm_resource_group.aj-rg-abc.location
  delegated_subnet_id           = azurerm_subnet.subnet2.id
  private_dns_zone_id           = azurerm_private_dns_zone.postgre_zone.id
  version             = "16" 
  storage_mb          = 32768 # 32GB
  sku_name            = "GP_Standard_D4s_v3"
  public_network_access_enabled = false
  
  authentication {
    active_directory_auth_enabled = true
    password_auth_enabled = false
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.user-id.id]
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.postgres_vnet_link
  ]
}
resource "azurerm_user_assigned_identity" "user-id" {
  name                = "user-identity"
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
  location            = azurerm_resource_group.aj-rg-abc.location
}


resource "azurerm_postgresql_flexible_server_active_directory_administrator" "entraAdmin" {
  server_name         = azurerm_postgresql_flexible_server.aj-postgreSQL-flex-abc.name
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azuread_service_principal.principal.object_id
  principal_name      = data.azuread_service_principal.principal.display_name
  principal_type      = "ServicePrincipal"
}