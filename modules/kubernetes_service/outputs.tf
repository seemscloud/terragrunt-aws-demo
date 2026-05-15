output "service_names" {
  value = { for k, service in kubernetes_service_v1.this : k => service.metadata[0].name }
}

output "service_namespaces" {
  value = { for k, service in kubernetes_service_v1.this : k => service.metadata[0].namespace }
}

output "load_balancer_hostnames" {
  value = { for k, service in kubernetes_service_v1.this : k => try(service.status[0].load_balancer[0].ingress[0].hostname, null) }
}
