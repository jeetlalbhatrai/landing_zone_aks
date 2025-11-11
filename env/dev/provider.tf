terraform {
  # required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.51.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "e18988e4-e1f4-4f06-9339-c63c8a22d3d9"
}
