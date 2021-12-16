# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = format("%s-%s-%s-storage", var.tags["project"], var.tags["company"], random_id.randomId.hex)
    resource_group_name         = azurerm_resource_group.myterraformgroup.name
    location                    = var.location
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = var.tags
}
