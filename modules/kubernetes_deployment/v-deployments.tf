variable "deployments" {
  type = map(object({
    namespace = optional(string, "default")
    replicas  = optional(number, 1)
    labels    = optional(map(string), {})
    container = object({
      name  = string
      image = string
      port  = optional(number)
    })
  }))
}
