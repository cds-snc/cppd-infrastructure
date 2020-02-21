resource "azurerm_storage_account" "file_upload" {
  name                     = "${lower(local.nameprefix)}cppdfileupload"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = merge( local.common_tags)
}

resource "azurerm_storage_container" "example" {
  name                  = "${lower(local.nameprefix)}vhds"
  storage_account_name  = azurerm_storage_account.file_upload.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "file_share" {
  name                 = "${lower(local.nameprefix)}fileshare"
  storage_account_name = azurerm_storage_account.file_upload.name
  quota                = 50
}
