# Configure the Microsoft Azure Provider
provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
    environment     = "china"
    features {}
}

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "myterraformgroup" {
    name     = "${var.lab_namespace}rg"
    location = "${var.location}"
    tags = {
        environment = "Azure Terraform Automation"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "${var.lab_namespace}vnet01"
    address_space       = ["10.21.0.0/16"]
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

    tags = {
        environment = "Azure Terraform Automation"
    }
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "publicnsg" {
    name                = "public-nsg"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    
        security_rule {
        name                       = "RDP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Azure Terraform Automation"
    }
}
resource "azurerm_network_security_group" "opnsg" {
    name                = "op-nsg"
    location            = "${var.location}"
    resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
    
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    
        security_rule {
        name                       = "RDP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "Azure Terraform Automation"
    }
}

# Create subnet
resource "azurerm_subnet" "publicsubnet" {
    name                 = "publicsn01"
    resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
    virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefix       = "10.21.0.0/23"
}
resource "azurerm_subnet_network_security_group_association" "publicsubnet_network_security_group_association" {
  subnet_id                 = "${azurerm_subnet.publicsubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.publicnsg.id}"
}
resource "azurerm_subnet" "opsubnet" {
    name                 = "opsn01"
    resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
    virtual_network_name = "${azurerm_virtual_network.myterraformnetwork.name}"
    address_prefix       = "10.21.2.0/23"
}
resource "azurerm_subnet_network_security_group_association" "opsubnet_network_security_group_association" {
  subnet_id                 = "${azurerm_subnet.opsubnet.id}"
  network_security_group_id = "${azurerm_network_security_group.opnsg.id}"
}

# Create Public IP
resource "azurerm_public_ip" "centos01pip" {
    name                         = "centos01pip"
    location                     = "${var.location}"
    resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
    allocation_method            = "Static"

    tags = {
        environment = "Azure Terraform Automation"
    }
}

# Create Network interface
resource "azurerm_network_interface" "centos01nic01" {
    name                        = "centos01nic01"
    location                    = "${var.location}"
    resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"

    ip_configuration {
        name                          = "centos01nic01"
        subnet_id                     = "${azurerm_subnet.publicsubnet.id}"
        private_ip_address_allocation = "Static"
        private_ip_address            = "10.21.0.4"
        public_ip_address_id          = "${azurerm_public_ip.centos01pip.id}"
    }

    tags = {
        environment = "Azure Terraform Automation"
    }
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "${azurerm_resource_group.myterraformgroup.name}sa01"
    resource_group_name         = "${azurerm_resource_group.myterraformgroup.name}"
    location                    = "${var.location}"
    account_kind                = "StorageV2"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "Azure Terraform Automation"
    }
}

# Create virtual machine
resource "azurerm_virtual_machine" "centos01" {
    name                  = "centos01"
    location              = "${var.location}"
    resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
    network_interface_ids = ["${azurerm_network_interface.centos01nic01.id}"]
    vm_size               = "Standard_D2s_v3"

    storage_os_disk {
        name              = "centos01OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        id = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/imagerg/providers/Microsoft.Compute/images/centos77image01"
    }

    os_profile {
        computer_name  = "centos01"
        admin_username = "${var.admin_username}"
        
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path     = "/home/${var.admin_username}/.ssh/authorized_keys"
            key_data = "${var.ssh_public_key_data}"
        }
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = "${azurerm_storage_account.mystorageaccount.primary_blob_endpoint}"
    }

    tags = {
        environment = "Azure Terraform Automation"
    }
}

resource "azurerm_eventhub_namespace" "eventhub01" {
  name                = "${var.lab_namespace}ehns01"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
  location            = "${var.location}"
  sku                 = "Standard"
  capacity            = 1

  tags = {
    environment = "Azure Terraform Automation"
  }
}
resource "azurerm_eventhub" "ingestion" {
  name                = "ingestion"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
  namespace_name      = "${azurerm_eventhub_namespace.eventhub01.name}"
  partition_count     = 1
  message_retention   = 1
}
resource "azurerm_eventhub" "alerting" {
  name                = "alerting"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
  namespace_name      = "${azurerm_eventhub_namespace.eventhub01.name}"
  partition_count     = 1
  message_retention   = 1
}

resource "azurerm_databricks_workspace" "databricksws01" {
  name                = "databricksws01"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
  location            = "${var.location}"
  sku                 = "standard"
}

resource "azurerm_logic_app_workflow" "lga01" {
  name                = "${var.lab_namespace}lga01"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
  location            = "${var.location}"

  tags = {
    Environment = "Azure Terraform Automation"
  }
}
