variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "web_server_location" {}
variable "web_server_rg" {}
variable "resource_prefix" {}
variable "web_server_address_space" {}



provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.32.0"
  subscription_id=var.subscription_id
  tenant_id=var.tenant_id
  client_id=var.client_id
  client_secret=var.client_secret
}


resource "azurerm_resource_group" "web_server_rg"{
    name = var.web_server_rg
    location = var.web_server_location
}

resource "azurerm_virtual_network" "web_server_vnet" {
     name="${var.resource_prefix}-vnet"
     location=var.web_server_location
     resource_group_name=azurerm_resource_group.web_server_rg.name
     address_space=[var.web_server_address_space]
  
}
