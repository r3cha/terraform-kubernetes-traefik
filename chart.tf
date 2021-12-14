# Install traefik helm_chart
resource "helm_release" "traefik" {
  namespace  = var.namespace
  name       = "traefik-v${replace(var.traefik_chart_version, ".", "-")}"
  repository = "https://helm.traefik.io/traefik"
  chart      = "traefik"
  version    = var.traefik_chart_version

  # If default_values == "" then apply default values from the chart if its anything else
  # then apply values file using the values_file input variable
  values = [var.default_values == "" ? var.default_values : file("${path.root}/${var.values_file}")]

  set {
    name  = "deployment.replicas"
    value = var.replica_count
  }

  depends_on = [
    kubernetes_namespace.traefik_namespace
  ]
}