# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "popsrox_resource_name" "maps_account" {
  name          = var.workload_name
  resource_type = "azurerm_maps_account"
  prefixes      = [var.org_name, module.mod_azure_region_lookup.location_short]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "mapacc"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "popsrox_resource_name" "maps_creator" {
  name          = var.workload_name
  resource_type = "azurerm_maps_account"
  prefixes      = [var.org_name, module.mod_azure_region_lookup.location_short]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "mapcr"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}
