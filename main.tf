terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Resource Group
resource "azurerm_resource_group" "smb" {
  name     = var.resource_group_name
  location = var.location
}

# Storage Account (Azure Files lives here)
resource "azurerm_storage_account" "files" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.smb.name
  location                 = azurerm_resource_group.smb.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

# Azure Files Share
resource "azurerm_storage_share" "fileshare" {
  name                 = "lane-files"
  storage_account_name = azurerm_storage_account.files.name
  quota                = var.file_share_quota_gb
}

# Storage Sync Service
resource "azurerm_storage_sync" "sync_service" {
  name                = "ss-smb-filesync"
  resource_group_name = azurerm_resource_group.smb.name
  location            = azurerm_resource_group.smb.location
}

# Sync Group (links the share to the sync service)
resource "azurerm_storage_sync_group" "sync_group" {
  name            = "sg-lane-files"
  storage_sync_id = azurerm_storage_sync.sync_service.id
}

# Cloud Endpoint (the Azure Files share = the cloud side of sync)
resource "azurerm_storage_sync_cloud_endpoint" "cloud_endpoint" {
  name                  = "ce-lane-files"
  storage_sync_group_id = azurerm_storage_sync_group.sync_group.id
  file_share_name       = azurerm_storage_share.fileshare.name
  storage_account_id    = azurerm_storage_account.files.id
}