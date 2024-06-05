# Create a public IP address
resource "azurerm_public_ip" "aj-publicIP-abc" {
  name                = "aj-publicIP-abc"
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
  location            = azurerm_resource_group.aj-rg-abc.location
  allocation_method   = "Dynamic"
}

# Create a network interface
resource "azurerm_network_interface" "aj-nic1-abc" {
  name                = "aj-nic1-abc"
  location            = azurerm_resource_group.aj-rg-abc.location
  resource_group_name = azurerm_resource_group.aj-rg-abc.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.aj-vnet1-abc.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.aj-publicIP-abc.id
  }
}

# Create a Windows virtual machine
resource "azurerm_windows_virtual_machine" "aj-vm1-abc" {
  name                = "aj-vm1-abc"
  resource_group_name = azurerm_resource_group.aj-rg-abc.name
  location            = azurerm_resource_group.aj-rg-abc.location
  size                = "Standard_B2s" # 2 vCPUs and 4GB RAM
  admin_username      = "adminuser"
  admin_password      = random_password.password.result
  network_interface_ids = [
    azurerm_network_interface.aj-nic1-abc.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }
}