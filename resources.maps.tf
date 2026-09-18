# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_maps_account" "maps_account" {
  name                = local.maps_account_name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku_name            = var.sku

  tags = merge(local.default_tags, var.add_tags)
}
