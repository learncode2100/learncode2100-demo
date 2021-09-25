# Example code to show basic logic of Terraform
# Create a RG, TF manages it and then create some resources manually.
# destroy it and see if manually created objects also get destroyed or not
terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "> 2.71.0"
    }
  }
  backend "remote" {
    organization = "learncode2100-demo"
    workspaces {
    name = "learncode2100-demo"
    }
  }
}

provider "azurerm" {
  features {
  }
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
}

variable "ARM_SUBSCRIPTION_ID" {
  
}
variable "ARM_CLIENT_ID" {
  
}
variable "ARM_CLIENT_SECRET" {
  
}
variable "ARM_TENANT_ID" {
  
}

resource "azurerm_resource_group" "demo" {
  name     = "demo-resources"
  location = "West Europe"
}

resource "azurerm_virtual_network" "demo" {
  name                = "demo-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
}

resource "azurerm_subnet" "demo" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "demo" {
  name = "demo-ip"
  resource_group_name = azurerm_resource_group.demo.name
  location = azurerm_resource_group.demo.location
  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "demo" {
  name                = "demo-nic"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.demo.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.demo.id
  }
}

resource "azurerm_linux_virtual_machine" "demo" {
  name                = "demo-machine"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  size                = "Standard_A1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.demo.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

output "example-ip" {
  value = azurerm_public_ip.demo.ip_address
}
