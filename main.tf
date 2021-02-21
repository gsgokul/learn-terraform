/*
* Provider block defines which provider they require
*/

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "6b369b79-f740-402e-8a57-2ce90e4b177b"
  client_id       = "4d730c69-407e-4766-8e44-fae721b947fd"
  client_secret   = "Km-G94~XAuGNlXYs1p938V4Elj_ctksKba"
  tenant_id       = "46a5fc3d-7ca0-420a-9448-1b5e87ef5858"
}

/*
* Resource Group
*/
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
}

/*
* App Service Plan
*/
resource "azurerm_app_service_plan" "this" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  kind                = "Windows"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

/*
* App Service
*/
resource "azurerm_app_service" "this" {
  name                = var.app_service_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  app_service_plan_id = azurerm_app_service_plan.this.id

  site_config {
    websockets_enabled = true
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"      = "azurerm_application_insights.this.instrumentation_key"
    "APPINSIGHTS_PORTALINFO"              = "ASP.NET"
    "APPINSIGHTS_PROFILERFEATURE_VERSION" = "1.0.0"
    "WEBSITE_HTTPLOGGING_RETENTION_DAYS"  = "35"
  }
}

/*
* Application Insights
*/
resource "azurerm_application_insights" "this" {
  name                = var.application_insights_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  application_type    = "web"
}
