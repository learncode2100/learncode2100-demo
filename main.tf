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
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "testrg" {
  name = "testrg002"
  location = "westeurope"
  tags = {
    "env" = "dev"
  }
}
