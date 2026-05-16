variable "eks_addons" {
  type = map(object({
    cluster_name                = string
    addon_name                  = string
    addon_version               = optional(string)
    configuration_values        = optional(string)
    resolve_conflicts_on_create = optional(string, "OVERWRITE")
    resolve_conflicts_on_update = optional(string, "OVERWRITE")
    tags                        = optional(map(string), {})
  }))
}
