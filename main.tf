# Example code to show basic logic of Terraform
# Create a RG, TF manages it and then create some resources manually.
# destroy it and see if manually created objects also get destroyed or not
terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "> 2.71.0"
    }
  }
  backend "remote" {
    organization = "learncode2100-demo"
    workspaces {
    name = "learncode2100-demo"
    }
  }
}

provider "azurerm" {
  features {
  }
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
}

variable "ARM_SUBSCRIPTION_ID" {
  
}
variable "ARM_CLIENT_ID" {
  
}
variable "ARM_CLIENT_SECRET" {
  
}
variable "ARM_TENANT_ID" {
  
}

resource "azurerm_resource_group" "testrg" {
  name = "testrg003"
  location = "westeurope"
  tags = {
    "env" = "prod"
  }
}
