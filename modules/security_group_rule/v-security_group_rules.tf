variable "security_group_rules" {
  type = map(object({
    type                     = string
    security_group_id        = string
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    cidr_blocks              = optional(list(string))
    source_security_group_id = optional(string)
  }))

  validation {
    condition = alltrue([
      for rule in values(var.security_group_rules) : contains(["ingress", "egress"], rule.type)
    ])
    error_message = "Security group rule type must be ingress or egress."
  }

  validation {
    condition = alltrue([
      for rule in values(var.security_group_rules) : (rule.cidr_blocks != null ? 1 : 0) + (rule.source_security_group_id != null ? 1 : 0) == 1
    ])
    error_message = "Each security group rule requires exactly one source."
  }
}
