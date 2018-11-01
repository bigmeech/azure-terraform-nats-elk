resource "azurerm_storage_account" "k8s_registry_storage" {
  name                     = "ubaacrstorage"
  resource_group_name      = "${azurerm_resource_group.test_rg.name}"
  location                 = "${azurerm_resource_group.test_rg.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_container_registry" "k8s_registry" {
  name                = "ubaacr"
  resource_group_name = "${azurerm_resource_group.test_rg.name}"
  location            = "${azurerm_resource_group.test_rg.location}"
  admin_enabled       = true
  sku                 = "Classic"
  storage_account_id  = "${azurerm_storage_account.k8s_registry_storage.id}"
}
