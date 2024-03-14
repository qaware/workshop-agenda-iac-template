terraform {
  required_version = ">=1.6"

  required_providers {
    azapi = {
      # https://github.com/Azure/terraform-provider-azapi/releases
      source  = "Azure/azapi"
      version = "1.12.1"
    }
    azurerm = {
      # https://github.com/hashicorp/terraform-provider-azurerm/releases
      source  = "hashicorp/azurerm"
      version = "3.97.1"
    }
    flux = {
      # https://github.com/fluxcd/terraform-provider-flux/releases
      source  = "fluxcd/flux"
      version = "1.2.3"
    }
    kubernetes = {
      # https://github.com/hashicorp/terraform-provider-kubernetes/releases
      source  = "hashicorp/kubernetes"
      version = "2.27.0"
    }
    null = {
      # https://github.com/hashicorp/terraform-provider-null/releases
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    random = {
      # https://github.com/hashicorp/terraform-provider-random/releases
      source  = "hashicorp/random"
      version = "3.6.0"
    }
    tls = {
      # https://github.com/hashicorp/terraform-provider-tls/releases
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }

  backend "azurerm" {}
}

################################################################################
# Provider configurations

provider "random" {}

resource "random_id" "prefix" {
  byte_length = 8
}

################################################################################

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  skip_provider_registration = true
}

data "azurerm_subscription" "current" {}

################################################################################

provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.admin_client_certificate)
  client_key             = base64decode(module.aks.admin_client_key)
  cluster_ca_certificate = base64decode(module.aks.admin_cluster_ca_certificate)
}

################################################################################

provider "flux" {
  kubernetes = {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.admin_client_certificate)
    client_key             = base64decode(module.aks.admin_client_key)
    cluster_ca_certificate = base64decode(module.aks.admin_cluster_ca_certificate)
  }

  git = {
    url = "https://github.com/${var.github_org}/${var.gitops_repo}"
    http = {
      username = "flux"
      password = var.github_token
    }
  }
}
