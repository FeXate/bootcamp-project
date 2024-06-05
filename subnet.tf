#Creates a NSG using name, and location and destination resource group as variables
resource "azurerm_network_security_group" "aj-nsg1-abc" {
  name                = "aj-nsg1-abc"
  location            = azurerm_resource_group.aj-rg-abc.location
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
}

#Creates a VNET using name, and location and destination resource group as variables, you have to configure your adress space and if you want to add subnets, you need to check for range
resource "azurerm_virtual_network" "aj-vnet1-abc" {
  name                = "aj-vnet1-abc"
  location            = azurerm_resource_group.aj-rg-abc.location
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
  address_space       = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.aj-rg-abc.name
  virtual_network_name = azurerm_virtual_network.aj-vnet1-abc.name
  
  address_prefixes     = ["10.0.0.0/27"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "subnet2"
  resource_group_name  = azurerm_resource_group.aj-rg-abc.name
  virtual_network_name = azurerm_virtual_network.aj-vnet1-abc.name
  address_prefixes     = ["10.0.0.32/27"]

  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  subnet_id                 = azurerm_subnet.subnet1.id
  network_security_group_id = azurerm_network_security_group.aj-nsg1-abc.id
}

