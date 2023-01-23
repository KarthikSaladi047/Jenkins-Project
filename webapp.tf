terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.40.0"
    }
  }
}

provider "azurerm" {
  # add your  Configuration details
  subscription_id = ""
  tenant_id       = ""
  client_id       = ""
  client_secret   = ""
}

resource "azurerm_resource_group" "web_app_rg" {
  name     = "Web-Resource-Group"
  location = "East US"
}

resource "azurerm_service_plan" "service_plan" {
  name                = "serviceplan22"
  resource_group_name = azurerm_resource_group.web_app_rg.name
  location            = azurerm_resource_group.web_app_rg.location
  os_type             = "Linux"
  sku_name            = "S1"
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "webapp22334455"
  resource_group_name = azurerm_resource_group.web_app_rg.name
  location            = azurerm_service_plan.service_plan.location
  service_plan_id     = azurerm_service_plan.service_plan.id
  site_config {
    application_stack {
      node_version = "14-lts"
    }
  }
}