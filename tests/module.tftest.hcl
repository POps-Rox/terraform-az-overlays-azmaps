# Functional tests for the Azure Maps overlay.
#
# These use mock_provider, so they execute without Azure credentials and are safe
# on fork pull requests. They exercise module decision logic that validate cannot
# see: naming precedence, create/use-existing conditionals, tag merging, and
# location passthrough.

mock_provider "azurerm" {
  mock_data "azurerm_resource_group" {
    defaults = {
      name     = "existing-rg"
      location = "eastus"
    }
  }
}

mock_provider "azapi" {}

mock_provider "popsrox" {
  mock_data "popsrox_resource_name" {
    defaults = {
      result = "anoa-eus-testworkload-dev-mapacc"
    }
  }
}

variables {
  location                     = "westus2"
  environment                  = "public"
  deploy_environment           = "dev"
  org_name                     = "anoa"
  workload_name                = "testworkload"
  create_maps_resource_group   = false
  existing_resource_group_name = "existing-rg"
  use_location_short_name      = true
}

run "generated_account_name_is_used_when_no_custom_name_given" {
  command = plan

  assert {
    condition     = azurerm_maps_account.maps_account.name == "anoa-eus-testworkload-dev-mapacc"
    error_message = "Expected generated Azure Maps account name, got: ${azurerm_maps_account.maps_account.name}"
  }
}

run "custom_account_name_overrides_generated_name" {
  command = plan

  variables {
    maps_account_custom_name = "my-explicit-maps"
  }

  assert {
    condition     = azurerm_maps_account.maps_account.name == "my-explicit-maps"
    error_message = "maps_account_custom_name must take precedence over the generated name, got: ${azurerm_maps_account.maps_account.name}"
  }
}

run "empty_custom_account_name_falls_through_to_generated_name" {
  command = plan

  variables {
    maps_account_custom_name = ""
  }

  assert {
    condition     = azurerm_maps_account.maps_account.name == "anoa-eus-testworkload-dev-mapacc"
    error_message = "An empty maps_account_custom_name must fall through to the generated name, got: ${azurerm_maps_account.maps_account.name}"
  }
}

run "existing_resource_group_path_uses_data_source" {
  command = plan

  assert {
    condition     = length(data.azurerm_resource_group.rgrp) == 1
    error_message = "create_maps_resource_group=false must read exactly one existing resource group"
  }

  assert {
    condition     = length(module.mod_maps_rg) == 0
    error_message = "create_maps_resource_group=false must not create a resource group module instance"
  }

  assert {
    condition     = azurerm_maps_account.maps_account.resource_group_name == "existing-rg"
    error_message = "Maps account must use the existing resource group name, got: ${azurerm_maps_account.maps_account.resource_group_name}"
  }
}

run "created_resource_group_path_uses_module" {
  command = plan

  variables {
    create_maps_resource_group   = true
    existing_resource_group_name = null
  }

  assert {
    condition     = length(data.azurerm_resource_group.rgrp) == 0
    error_message = "create_maps_resource_group=true must not read an existing resource group"
  }

  assert {
    condition     = length(module.mod_maps_rg) == 1
    error_message = "create_maps_resource_group=true must create exactly one resource group module instance"
  }
}

run "caller_tags_are_merged_with_default_tags" {
  command = plan

  variables {
    add_tags = {
      costCenter = "cc-1234"
    }
  }

  assert {
    condition     = azurerm_maps_account.maps_account.tags["costCenter"] == "cc-1234"
    error_message = "Tags passed via add_tags must appear on the Maps account"
  }

  assert {
    condition     = azurerm_maps_account.maps_account.tags["deployedBy"] == "AzureNoOpsTF [default]"
    error_message = "Default tags must be merged onto the Maps account"
  }
}

run "location_is_passed_through_from_resource_group_lookup" {
  command = plan

  assert {
    condition     = azurerm_maps_account.maps_account.location == "eastus"
    error_message = "Maps account location must come from the selected resource group lookup, got: ${azurerm_maps_account.maps_account.location}"
  }
}
