
# Create virtual machine
resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = format("%s-%s-vm", var.tags["project"], var.tags["company"])
    location              = var.location
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    vm_size               = var.vm_size

    storage_os_disk {
        name              = format("%s-%s-disk", var.tags["project"], var.tags["company"])
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Premium_LRS"
    }

    storage_image_reference = var.instance_data

    os_profile {
        computer_name  = format("%s-%s-myvm", var.tags["project"], var.tags["company"])
        admin_username = "azureuser"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/azureuser/.ssh/authorized_keys"
            key_data = var.public-key
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = var.tags
}
