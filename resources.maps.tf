# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_maps_account" "maps_account" {
  name                = local.maps_account_name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku_name            = var.sku

  tags = merge(local.default_tags, var.add_tags)
}

resource "azurerm_maps_creator" "maps_creator" {
  name            = local.maps_creator_name
  maps_account_id = azurerm_maps_account.maps_account.id
  location        = var.sku == "G2" ? "eastus2" : local.location
  storage_units   = var.storage_units

  tags = merge(local.default_tags, var.add_tags)
}