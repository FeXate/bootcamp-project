#Creates a NSG using name, and location and destination resource group as variables
resource "azurerm_network_security_group" "aj-nsg1-abc" {
  name                = "aj-nsg1-abc"
  location            = azurerm_resource_group.aj-rg-abc.location
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
}

#Creates a VNET using name, and location and destination resource group as variables, you have to configure your adress space and if you want to add subnets, you need to check for range
resource "azurerm_virtual_network" "aj-vnet1-abc" {
  name                = "aj-vnet1-abc"
  location            = "west europe"
  resource_group_name = "aj-rg-abc"
  address_space       = ["10.0.0.0/24"]

  subnet {
    name           = "subnet1"
    address_prefix = "10.0.0.0/27"
  }

  subnet {
    name           = "subnet2"
    address_prefix = "10.0.0.32/27"
    security_group = azurerm_network_security_group.aj-nsg1-abc.id
  }

  tags = {
    owner = "Adam Jelassi"
  }
}