terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "gzeru_rg" {
  name     = "zeru_rg"
  location = "West Europe"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "zeruterraform"
    storage_account_name = "zerustrgaccount"
    container_name       = "tfstatefile"
    key                  = "terraform.tfstate"
  }
}

resource "azurerm_container_group" "gzeru_rg" {
  name                = "weatherapi"
  location            = azurerm_resource_group.gzeru_rg.location
  resource_group_name = azurerm_resource_group.gzeru_rg.name
  ip_address_type     = "Public"
  dns_name_label      = "gzeruwapi"
  os_type             = "Linux"

  container {
    name   = "weatherapi"
    image  = "gzeru/ukweatherapi"
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}