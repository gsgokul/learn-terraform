/*
* Provider block defines which provider they require
*/

provider "azurerm" {
  version = "= 2.46"
  features {}
}

terraform {
  backend "azurerm" {}
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
    "APPINSIGHTS_INSTRUMENTATIONKEY"      = "${azurerm_application_insights.this.instrumentation_key}"
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
