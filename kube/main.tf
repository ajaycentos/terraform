variable "subscription_id" {}
variable "tenant_id" {}
variable "client_id" {}
variable "client_secret" {}

variable "server_location" {}
variable "server_rg" {}
variable "cluster_name" {}
variable "dns_prefix" {}
variable "ssh_public_key" {}
variable "agent_count" {}






provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.32.0"
  subscription_id=var.subscription_id
  tenant_id=var.tenant_id
  client_id=var.client_id
  client_secret=var.client_secret
}

resource "azurerm_resource_group" "k8s" {
  name     = var.server_rg
  location = var.server_location
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name=var.cluster_name
  location=azurerm_resource_group.k8s.location
  resource_group_name=azurerm_resource_group.k8s.name
  dns_prefix=var.dns_prefix

  linux_profile{
    admin_username="myadmin"

    ssh_key {
      key_data=file(var.ssh_public_key)

    }
  }

  agent_pool_profile {
    name            = "default"
    count           = var.agent_count
    vm_size         = "Standard_DS1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

 
}
