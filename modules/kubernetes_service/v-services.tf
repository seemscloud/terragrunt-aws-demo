variable "services" {
  type = map(object({
    namespace              = optional(string, "default")
    type                   = optional(string, "ClusterIP")
    selector               = map(string)
    annotations            = optional(map(string), {})
    labels                 = optional(map(string), {})
    wait_for_load_balancer = optional(bool, false)
    port = object({
      name        = optional(string)
      port        = number
      target_port = number
      protocol    = optional(string, "TCP")
    })
  }))
}
