# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_maps_rg.*.resource_group_name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_maps_rg.*.resource_group_location, [""]), 0)
  maps_account_name   = coalesce(var.maps_account_custom_name, data.popsrox_resource_name.maps_account.result)
  maps_creator_name   = coalesce(var.maps_creator_custom_name, data.popsrox_resource_name.maps_creator.result)
}
