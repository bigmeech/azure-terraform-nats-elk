locals {
  go_version = "1.11.1"
  os_arch = "linux-amd64"
}
resource "azurerm_virtual_machine" "gnatsd_01" {
  name                  = "${var.prefix}-gnatsd_cluster-0"
  location              = "${azurerm_resource_group.test_rg.location}"
  resource_group_name   = "${azurerm_resource_group.test_rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "Standard_F2s_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "gnatsd01disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "gnatsd-01"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path = "/home/${var.vm_username}/.ssh/authorized_keys"
      key_data = "${var.ssh_pub_key}"
    }
  }

  tags {
    environment = "test"
  }

  provisioner "file" {
    source = "scripts/bootstrap-gnatsd.sh"
    destination = "/tmp/bootstrap-gnatsd.sh"

    connection {
      type        = "ssh"
      user        = "${var.vm_username}"
      private_key = "${file(var.ssh_priv_keypath)}"
      agent = true
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "${var.vm_username}"
      private_key = "${file(var.ssh_priv_keypath)}"
      agent = true
    }

    inline = [
      "chmod +x /tmp/bootstrap-gnatsd.sh",
      "/tmp/bootstrap-gnatsd.sh"
    ]
  }
}

resource "azurerm_network_security_group" "gnatsd_sg" {
  name                = "uba-gnatsd-sg"
  location            = "${azurerm_resource_group.test_rg.location}"
  resource_group_name = "${azurerm_resource_group.test_rg.name}"

  security_rule {
    name                       = "allow_gnatsd_connections"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = [4242,8222,4222,6222]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_ssh_connections"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags {
    environment = "test"
  }
}

resource "azurerm_public_ip" "gnatsd_public_ip" {
  name                         = "gnatsd-public-ip"
  location                     = "${azurerm_resource_group.test_rg.location}"
  resource_group_name          = "${azurerm_resource_group.test_rg.name}"
  domain_name_label            = "gnatsd01"
  public_ip_address_allocation = "dynamic"

  tags {
    environment = "test"
  }
}

output "nats_server_name" {
  value = "${azurerm_public_ip.gnatsd_public_ip.domain_name_label}.uksouth.cloudapp.azure.com:4222"
}

output "nats_server_ip_address" {
  value = "${azurerm_public_ip.gnatsd_public_ip.ip_address}"
}

