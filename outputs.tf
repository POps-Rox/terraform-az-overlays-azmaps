# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

output "maps_account_name" {
  value = azurerm_maps_account.maps_account.name
}

output "maps_account_id" {
  value = azurerm_maps_account.maps_account.id
}

output "maps_account_sku" {
  value = azurerm_maps_account.maps_account.sku_name
}
