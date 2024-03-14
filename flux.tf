resource "flux_bootstrap_git" "this" {
  path = "clusters/${module.aks.aks_name}"
}
