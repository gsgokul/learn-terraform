# General
variable "resource_group_name" {
  description = "The name of the resource group"
}

variable "location" {
  description = "The Azure region in which all resources should be created"
}

# App Service
variable "app_service_plan_name" {
  description = "The name of the app service plan for the backend"
}

variable "app_service_name" {
  description = "The name of the app service for the backend"
}

# Application Insights
variable "application_insights_name" {
  description = "The name of the application insights resource"
}
