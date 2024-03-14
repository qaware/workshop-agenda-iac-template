variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
  nullable    = false
}

variable "environment" {
  type        = string
  description = "The deployment environment."
  nullable    = false

  validation {
    condition     = var.environment != ""
    error_message = "The environment must not be empty."
  }
}

variable "github_org" {
  description = "The name of the GitHub organisation."
  type        = string
  nullable    = false

  validation {
    condition     = var.github_org != ""
    error_message = "The GitHub organisation must not be empty."
  }
}

variable "github_token" {
  description = "The GitHub token to use for authenticating with the GitHub API."
  type        = string
  sensitive   = true
  nullable    = false

  validation {
    condition     = var.github_token != ""
    error_message = "The GitHub token must not be empty."
  }
}

variable "gitops_repo" {
  description = "The name of the GitOps repository."
  type        = string
  nullable    = false

  validation {
    condition     = var.gitops_repo != ""
    error_message = "The GitOps repository must not be empty."
  }
}
