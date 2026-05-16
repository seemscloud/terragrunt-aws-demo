variable "services" {
  type = map(object({
    namespace                   = optional(string, "default")
    type                        = optional(string, "ClusterIP")
    selector                    = map(string)
    annotations                 = optional(map(string), {})
    labels                      = optional(map(string), {})
    external_traffic_policy     = optional(string)
    load_balancer_source_ranges = optional(list(string))
    wait_for_load_balancer      = optional(bool, false)
    port = object({
      name        = optional(string)
      port        = number
      target_port = number
      protocol    = optional(string, "TCP")
    })
  }))
}
