output "deployment_names" {
  value = { for k, deployment in kubernetes_deployment_v1.this : k => deployment.metadata[0].name }
}

output "deployment_namespaces" {
  value = { for k, deployment in kubernetes_deployment_v1.this : k => deployment.metadata[0].namespace }
}
