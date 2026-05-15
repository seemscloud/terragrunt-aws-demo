resource "kubernetes_service_v1" "this" {
  for_each = var.services

  metadata {
    name        = each.key
    namespace   = each.value.namespace
    annotations = each.value.annotations
    labels      = each.value.labels
  }

  spec {
    type     = each.value.type
    selector = each.value.selector

    port {
      name        = each.value.port.name
      port        = each.value.port.port
      target_port = each.value.port.target_port
      protocol    = each.value.port.protocol
    }
  }

  wait_for_load_balancer = each.value.wait_for_load_balancer
}
