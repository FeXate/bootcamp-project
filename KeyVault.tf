resource "azurerm_key_vault" "aj-KeyVault" {
  name                        = "aj-KeyVault-abc1"
  location                    = azurerm_resource_group.aj-rg-abc.location
  resource_group_name         = azurerm_resource_group.aj-rg-abc.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name = "premium"
}
data "azurerm_subscription" "primary" {
}

resource "azurerm_role_assignment" "rbac" {
  scope                = azurerm_key_vault.aj-KeyVault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_windows_virtual_machine.aj-vm1-abc.identity[0].principal_id
}

  /*access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List"
    ]

    secret_permissions = [
      "Get",
      "List",
    ]

    storage_permissions = [
      "Get",
      "List",
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_windows_virtual_machine.aj-vm1-abc.identity[0].principal_id

    secret_permissions = [
      "Set",
      "Delete",
      "Get",
      "List",
    ]
  }*/
