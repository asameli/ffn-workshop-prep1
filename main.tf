provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
  }
}

variable "prefix" {
  description = "Enter the prefix for the resource names"
  type        = string
  default     = "AS-FFN-Workshop"
}

variable "resource_group_name" {
  description = "Enter the name for the resource group"
  type        = string
}

resource "azurerm_resource_group" "ffn-workshop" {
  name     = var.resource_group_name
  location = "switzerlandnorth"
}

resource "azurerm_public_ip" "ffn-workshop" {
  name                = "${var.prefix}-public-ip"
  location            = azurerm_resource_group.ffn-workshop.location
  resource_group_name = azurerm_resource_group.ffn-workshop.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_security_group" "ffn-workshop" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.ffn-workshop.location
  resource_group_name = azurerm_resource_group.ffn-workshop.name
}

resource "azurerm_network_security_rule" "ffn-workshop" {
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes      = ["0.0.0.0/0"]
  destination_address_prefixes = ["*"]
  resource_group_name         = azurerm_resource_group.ffn-workshop.name
  network_security_group_name = azurerm_network_security_group.ffn-workshop.name
}

resource "azurerm_virtual_network" "ffn-workshop" {
  name                = "${var.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ffn-workshop.location
  resource_group_name = azurerm_resource_group.ffn-workshop.name
}

resource "azurerm_subnet" "ffn-workshop" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.ffn-workshop.name
  virtual_network_name = azurerm_virtual_network.ffn-workshop.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "ffn-workshop" {
  subnet_name                 = "${var.prefix}-subnet"
  network_security_group_name = azurerm_network_security_group.ffn-workshop.name
}

resource "azurerm_network_interface" "ffn-workshop" {
  name                      = "${var.prefix}-nic"
  location                  = azurerm_resource_group.ffn-workshop.location
  resource_group_name       = azurerm_resource_group.ffn-workshop.name

  ip_configuration {
    name                          = "${var.prefix}-ip-config"
    subnet_id                     = azurerm_subnet.ffn-workshop.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ffn-workshop.id
  }
}

resource "azurerm_linux_virtual_machine" "ffn-workshop" {
  name                = "${var.prefix}-vm"
  location            = azurerm_resource_group.ffn-workshop.location
  resource_group_name = azurerm_resource_group.ffn-workshop.name
  size                = "Standard_DS1_v2"
  admin_username      = "adminuser"
  admin_password      = random_password.ffn-workshop.result

  network_interface_ids = [azurerm_network_interface.ffn-workshop.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

resource "random_password" "ffn-workshop" {
  length           = 16
  special          = true
  override_special = "!@#"
}

output "vm_password" {
  value = random_password.ffn-workshop.result
}
