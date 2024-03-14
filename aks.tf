module "aks" {
  # https://github.com/Azure/terraform-azurerm-aks/tags
  source = "git::https://github.com/Azure/terraform-azurerm-aks.git?ref=a094a4deab23bebcd4dd8f64208514eb1a835482" # 8.0.0

  cluster_name                      = var.environment
  cluster_name_random_suffix        = true
  log_analytics_workspace_enabled   = false
  oidc_issuer_enabled               = true
  os_disk_size_gb                   = 60
  prefix                            = random_id.prefix.hex
  rbac_aad                          = true
  rbac_aad_azure_rbac_enabled       = true
  rbac_aad_managed                  = true
  resource_group_name               = var.resource_group_name
  role_based_access_control_enabled = true
  sku_tier                          = "Standard"
  workload_identity_enabled         = true
}

################################################################################

resource "azurerm_user_assigned_identity" "azure_service_operator" {
  name                = "azure-service-operator"
  location            = module.aks.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_federated_identity_credential" "azure_service_operator" {
  name                = azurerm_user_assigned_identity.azure_service_operator.name
  resource_group_name = azurerm_user_assigned_identity.azure_service_operator.resource_group_name
  parent_id           = azurerm_user_assigned_identity.azure_service_operator.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = module.aks.oidc_issuer_url
  subject             = "system:serviceaccount:azureserviceoperator-system:azureserviceoperator-default"
}

resource "azurerm_role_assignment" "azure_service_operator_owner" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.azure_service_operator.principal_id
}
