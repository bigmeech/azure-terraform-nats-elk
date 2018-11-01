
provider "azurerm" {
  subscription_id     = "${var.subscription_id}"
  client_id           = "${var.client_id}"
  client_secret       = "${var.client_secret}"
  tenant_id           = "${var.tenant_id}"
}

resource "azurerm_resource_group" "test_rg" {
  name = "uba-notify-test-rg"
  # location = "West Europe"
  location = "uksouth"
}