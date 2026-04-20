locals {
  ssm_prefix   = "/${var.service_name}/${lower(var.environment)}"
  oidc_host    = replace(var.oidc_provider_url, "https://", "")
  role_name    = "${var.project_name}-${var.environment}-${var.service_name}"
  project      = "cape-digi"
  service_name = "digi-identity"
  namespace    = "cape-digi"
}
