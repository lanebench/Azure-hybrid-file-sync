output "storage_account_name" {
  value = azurerm_storage_account.files.name
}

output "file_share_name" {
  value = azurerm_storage_share.fileshare.name
}

output "sync_service_name" {
  value = azurerm_storage_sync.sync_service.name
}