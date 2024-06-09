terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }
}

provider "azurerm" {
  subscription_id = "79d25b68-c37f-4c63-9de7-95ed15a6c2e7"
  tenant_id       = "59f4bfff-76be-4144-ad87-688e9734098b"
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "aj-rg-abc" {
  name     = "aj-rg-abc"
  location = "West Europe"
}
