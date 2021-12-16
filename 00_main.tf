# Configure Terraform provider and remote state
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.89.0"
    }
  }
    backend "azurerm" {}

}
# Configure the Microsoft Azure Provider
provider "azurerm" {
    features {}
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "myterraformgroup" {
    name     = format("%s-%s-rg", var.tags["project"], var.tags["company"])
    location = var.location

    tags = var.tags
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = format("%s-%s-vnet", var.tags["project"], var.tags["company"])
    address_space       = [var.address_space]
    location            = var.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    tags = var.tags
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = format("%s-%s-subnet", var.tags["project"], var.tags["company"])
    resource_group_name  = azurerm_resource_group.myterraformgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes       = [var.address_prefix]
}

# Create public IPs
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = format("%s-%s-ip", var.tags["project"], var.tags["company"])
    location                     = var.location
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    public_ip_address_allocation = "dynamic"

    tags = var.tags
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = format("%s-%s-networksg", var.tags["project"], var.tags["company"])
    location            = var.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
    }

    tags = var.tags
}

# Create network interface
resource "azurerm_network_interface" "myterraformnic" {
    name                      = format("%s-%s-nic", var.tags["project"], var.tags["company"])
    location                  = var.location
    resource_group_name       = azurerm_resource_group.myterraformgroup.name
    network_security_group_id = azurerm_network_security_group.myterraformnsg.id

    ip_configuration {
        name                          = format("%s-%s-nic-config", var.tags["project"], var.tags["company"])
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags = var.tags
}

# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.myterraformgroup.name
    }

    byte_length = 8
}
