resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.test_rg.location}"
  resource_group_name = "${azurerm_resource_group.test_rg.name}"
}

resource "azurerm_subnet" "internal_subnet" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = "${azurerm_resource_group.test_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = "${azurerm_resource_group.test_rg.location}"
  resource_group_name = "${azurerm_resource_group.test_rg.name}"
  network_security_group_id = "${azurerm_network_security_group.gnatsd_sg.id}"

  ip_configuration {
    name                          = "gnatsd_ip_config"
    subnet_id                     = "${azurerm_subnet.internal_subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.gnatsd_public_ip.id}"
  }
}