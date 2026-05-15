resource "kubernetes_deployment_v1" "this" {
  for_each = var.deployments

  metadata {
    name      = each.key
    namespace = each.value.namespace
    labels    = merge(each.value.labels, { app = each.key })
  }

  spec {
    replicas = each.value.replicas

    selector {
      match_labels = merge(each.value.labels, { app = each.key })
    }

    template {
      metadata {
        labels = merge(each.value.labels, { app = each.key })
      }

      spec {
        container {
          name  = each.value.container.name
          image = each.value.container.image

          dynamic "port" {
            for_each = each.value.container.port == null ? [] : [each.value.container.port]

            content {
              container_port = port.value
            }
          }
        }
      }
    }
  }
}
